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

import SwiftSyntaxBuilder

extension FunctionDeclSyntax {
    func canThrow() -> Bool {
        signature.effectSpecifiers?.throwsClause != nil
    }

    func isAsync() -> Bool {
        signature.effectSpecifiers?.asyncSpecifier != nil
    }


    func call(
        base: (some ExprSyntaxProtocol)?,
        @LabeledExprListBuilder argumentList: () -> LabeledExprListSyntax = { [] }
    ) -> ExprSyntaxProtocol {

        let accessExpression: ExprSyntaxProtocol = if let base {
            MemberAccessExprSyntax(
                base: base,
                name: name
            )
        } else {
            DeclReferenceExprSyntax(baseName: name)
        }

        var callExpression: ExprSyntaxProtocol = FunctionCallExprSyntax(
            callee: accessExpression,
            argumentList: argumentList
        )

        if self.isAsync() {
            callExpression = AwaitExprSyntax(expression: callExpression)
        }

        if self.canThrow() {
            callExpression = TryExprSyntax(expression: callExpression)
        }

        return callExpression
    }

    func call(
        baseName: TokenSyntax? = nil,
        @LabeledExprListBuilder argumentList: () -> LabeledExprListSyntax = { [] }
    ) -> ExprSyntaxProtocol {
        call(
            base: baseName.flatMap({ DeclReferenceExprSyntax(baseName:$0) }),
            argumentList: argumentList
        )
    }
}

struct RouteMacro: PeerMacro {
    // MARK: Expansion
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

        var routeMethodCallExpr: ExprSyntaxProtocol = FunctionCallExprSyntax(
            callee: DeclReferenceExprSyntax(baseName: functionDecl.name),
            argumentList: { routeMethodCallArguments }
        )

        if functionDecl.isAsync() {
            routeMethodCallExpr = AwaitExprSyntax(expression: routeMethodCallExpr)
        }

        if functionDecl.canThrow() {
            routeMethodCallExpr = TryExprSyntax(expression: routeMethodCallExpr)
        }

        blocks.append(.init(item: .stmt(.init(ReturnStmtSyntax(expression: routeMethodCallExpr)))))

        let parameterClause = FunctionParameterClauseSyntax(
            parameters: [.init(firstName: "request", type: IdentifierTypeSyntax(name: "Request"))]
        )

        let throwsClause = if !functionDecl.signature.parameterClause.parameters.isEmpty {
            ThrowsClauseSyntax(throwsSpecifier: .keyword(.throws))
        } else {
            functionDecl.signature.effectSpecifiers?.throwsClause
        }

        let function = FunctionDeclSyntax(
            name: functionDecl.name,
            signature: FunctionSignatureSyntax(
                parameterClause: parameterClause,
                effectSpecifiers: .init(
                    asyncSpecifier: functionDecl.signature.effectSpecifiers?.asyncSpecifier,
                    throwsClause: throwsClause
                ),
                returnClause: functionDecl.signature.returnClause
            ),
            body: .init(statements: .init(blocks))
        )

        return [.init(function)]
    }

    // MARK: Parameter Decoder
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
            base: DeclReferenceExprSyntax(baseName: "RouteParameters"),
            name: "\(raw: attribute.attributeName.trimmedDescription)"
        )

        return FunctionCallExprSyntax(
            callee: FunctionCallExprSyntax(callee: callee, argumentList: {
                LabeledExprSyntax(expression: ExprSyntax("\(parameterDecl.type).self"))
                arguments
            }),
            argumentList: { LabeledExprSyntax(label: "from", expression: ExprSyntax("request")) }
        )
    }
}
