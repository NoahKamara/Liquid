import SwiftSyntaxMacros
import SwiftSyntax

let allowedParameterAttributeNames: [String] = [
    "Query",
    "Header",
    "Path",
    "Body"
]

extension MacroExpansionContext {
    func uniqueFunction(_ functionDecl: FunctionDeclSyntax) -> TokenSyntax {
        let parameters = functionDecl.signature.parameterClause.parameters
            .map({ $0.firstName.identifier?.name ?? "_" })
            .joined(separator: "_")

        return makeUniqueName(functionDecl.name.text+parameters)
    }

    func uniqueRouteName(_ routeAttrib: RouteAttribute) -> TokenSyntax {
        let parameters = routeAttrib.path
            .map({
                $0.trimmedDescription
            })
            .joined(separator: "_")
        
        var inputString = routeAttrib.method.trimmedDescription+parameters

        inputString.replace("\"", with: "")
        inputString.replace(".", with: "_")

        return makeUniqueName(inputString)
    }
}


struct RouteMacro: PeerMacro {
    static func buildParameterDecoder(
        _ parameterDecl: FunctionParameterSyntax
    ) throws(DiagnosticError) -> FunctionCallExprSyntax  {
        let attributes: [AttributeSyntax] = parameterDecl.attributes
            .compactMap({ $0.as(AttributeSyntax.self) })
            .filter({
                allowedParameterAttributeNames.contains($0.attributeName.trimmedDescription)
            })

        guard let attribute = attributes.first, attributes.count == 1 else {
            throw DiagnosticBuilder(for: parameterDecl)
                .message("Route Parameter '\(parameterDecl.firstName.identifier?.name ?? "_")' missing attribute")
                .error()
        }

        let arguments: LabeledExprListSyntax = if let attributeArguments = attribute.arguments {
            if let arguments = attributeArguments.as(LabeledExprListSyntax.self) {
                arguments
            } else {
                throw DiagnosticBuilder(for: attributeArguments)
                    .message("Expected LabeledExprListSyntax but got \(attributeArguments.syntaxNodeType)")
                    .error()
            }
        } else if let paramIdentifier = parameterDecl.firstName.identifier ?? parameterDecl.secondName?.identifier {
            LabeledExprListSyntax {
                LabeledExprSyntax(expression: StringLiteralExprSyntax(content: paramIdentifier.name))
            }
        } else {
            LabeledExprListSyntax()
        }

        let callee = MemberAccessExprSyntax(
            base: DeclReferenceExprSyntax(baseName: "RouteParamters"),
            name: "\(raw: attribute.attributeName.trimmedDescription)"
        )

        return FunctionCallExprSyntax(callee: callee, argumentList: { arguments })
    }

    
    static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        do {
            return try build(
                node: node,
                declaration: declaration,
                context: context
            )
        } catch {
            context.diagnose(error.diagnostic)
            return []
        }
    }


    static func build(
        node: AttributeSyntax,
        declaration: some DeclSyntaxProtocol,
        context: some MacroExpansionContext
    ) throws(DiagnosticError) -> [DeclSyntax] {
        guard let functionDecl = declaration.as(FunctionDeclSyntax.self) else {
            DiagnosticBuilder(for: declaration)
                .message("Macro can only be applied to Methods & Functions")
                .emit(context)
            return []
        }

        var variableNames = [TokenSyntax]()

        var blocks = [CodeBlockItemSyntax]()

        // MARK: Parameters
        for (i, paramDecl) in functionDecl.signature.parameterClause.parameters.enumerated() {
            let name = if let firstName = paramDecl.firstName.identifier {
                firstName.name
            } else if let secondName = paramDecl.secondName?.identifier {
                "param_\(i)_\(secondName.name)"
            } else {
                "param_\(i)"
            }

            let variableName = context.makeUniqueName(name)

            let parameterDecoder = try buildParameterDecoder(paramDecl)

            let parameterVariableDecl = VariableDeclSyntax(
                .let,
                name: .init(IdentifierPatternSyntax(identifier: variableName)),
                initializer: .init(value: TryExprSyntax(expression: parameterDecoder))
            )

            blocks.append(.init(item: .decl(.init(parameterVariableDecl))))
            variableNames.append(variableName)
        }

        // MARK: Route Method Call
        // Build pairs function arguments of firstName: variableName
        let routeMethodCallArguments = zip(
            functionDecl.signature.parameterClause.parameters.map(\.firstName.identifier?.name),
            variableNames
        ).map { (label, variableName) in
            LabeledExprSyntax(label: label, expression: DeclReferenceExprSyntax(baseName: variableName))
        }

        let routeMethodCallExpr = FunctionCallExprSyntax(
            callee: DeclReferenceExprSyntax(baseName: functionDecl.name),
            argumentList: { routeMethodCallArguments }
        )

        blocks.append(.init(item: .stmt(.init(ReturnStmtSyntax(expression: routeMethodCallExpr)))))

        let parameterClause = FunctionParameterClauseSyntax(
            parameters: [.init(firstName: "request", type: IdentifierTypeSyntax(name: "Request"))]
        )

        let routeAttribs = try RouteAttribute(from: node, functionName: functionDecl.name)

        let function = FunctionDeclSyntax(
            name: context.makeUniqueName(functionDecl.name.text+"_"+functionDecl.signature.parameterClause.parameters.trimmedDescription),
            signature: FunctionSignatureSyntax(
                parameterClause: parameterClause,
                returnClause: functionDecl.signature.returnClause
            ),
            body: .init(statements: .init(blocks))
        )

        return [.init(function)]
    }
}
