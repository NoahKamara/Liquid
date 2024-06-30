import SwiftSyntaxMacros
import SwiftSyntax

let allowedRouteAliases = [
    "GET", "PUT", "ACL", "HEAD", "POST", "COPY", "LOCK", "MOVE", "BIND", "LINK", "PATCH", "TRACE",
    "MKCOL", "MERGE", "PURGE", "NOTIFY", "SEARCH", "UNLOCK", "REBIND", "UNBIND", "REPORT", "DELETE",
    "UNLINK", "CONNECT", "MSEARCH", "OPTIONS", "PROPFIND", "CHECKOUT", "PROPPATCH", "SUBSCRIBE",
    "MKCALENDAR", "MKACTIVITY", "UNSUBSCRIBE", "SOURCE"
]

let allowedRouteDecorators = ["Route"] + allowedRouteAliases

extension AttributeListSyntax {
    func get(named name: TokenSyntax) -> AttributeSyntax? {
        for element in self {
            if let attribute = element.as(AttributeSyntax.self), attribute.attributeName.trimmedDescription == name.trimmedDescription {
                return attribute
            }
        }
        return nil
    }

    func containsAttribute(where condition: (AttributeSyntax) -> Bool) -> AttributeSyntax? {
        for element in self {
            if let attribute = element.as(AttributeSyntax.self), condition(attribute) {
                return attribute
            }
        }
        return nil
    }
}

struct RouteAttribute: CustomStringConvertible {
    var description: String {
        "\(method) \(path.map(\.trimmedDescription).joined(separator: "/"))"
    }

    internal init(method: MemberAccessExprSyntax, path: [ExprSyntax]) {
        self.method = method
        self.path = path
    }

    let method: MemberAccessExprSyntax
    let path: [ExprSyntax]

    private static func parseMethod(
        attribute: AttributeSyntax,
        arguments: inout [LabeledExprSyntax]
    ) throws(DiagnosticError) -> MemberAccessExprSyntax {
        let attributeName = attribute.attributeName.trimmedDescription

        if ["Route", "CollectableRoute"].contains(attributeName) {
            // @Route(.GET) -> .GET
            guard let argument = arguments.first, let method = argument.expression.as(MemberAccessExprSyntax.self) else {
                throw DiagnosticBuilder(for: attribute)
                    .message("Expected first argument to be HTTPMethod")
                    .error()
            }

            arguments = Array(arguments.dropFirst())
            return method

        } else if allowedRouteAliases.contains(attributeName) {
            // @GET -> .GET
            return .init(period: .periodToken(), declName: .init(baseName: .identifier(attributeName)))
        }

        throw DiagnosticBuilder(for: attribute)
            .message("Expected Route CollectableRoute or one of \(allowedRouteAliases.joined(separator: ", ")))")
            .error()
    }

    init(from attribute: AttributeSyntax, functionName: TokenSyntax) throws(DiagnosticError) {
        let attributeName = attribute.attributeName.trimmedDescription
        var arguments = attribute.arguments?.as(LabeledExprListSyntax.self) ?? []

        // MARK: Method
        let method: MemberAccessExprSyntax = if ["Route", "CollectableRoute"].contains(attributeName) {
            // @Route(.GET) -> .GET
            if let argument = arguments.first,
               let method = argument.expression.as(MemberAccessExprSyntax.self) {
                method
            } else {
                throw DiagnosticBuilder(for: attribute)
                    .message("Expected first argument to be HTTPMethod")
                    .error()
            }

        } else if allowedRouteAliases.contains(attributeName) {
            // @GET -> .GET
            .init(period: .periodToken(), declName: .init(baseName: .identifier(attributeName)))
        } else {
            throw DiagnosticBuilder(for: attribute)
                .message("Expected Route or one of \(allowedRouteAliases.joined(separator: ", ")))")
                .error()
        }


        // MARK: Path
        if attributeName == "Route" {
            arguments = LabeledExprListSyntax(arguments.dropFirst())
        }

        let path = if arguments.isEmpty {
            [ExprSyntax(StringLiteralExprSyntax(content: functionName.trimmedDescription))]
        } else {
            arguments.map(\.expression)
        }

        self.init(method: method, path: path)
    }
}
extension RouteAttribute {
    func decorator(context: MacroExpansionContext) -> AttributeSyntax {
        AttributeSyntax("CollectableRoute") {
            .init(expression: method)
            path.map({ .init(expression: $0) })
        }
    }
}
struct RouteCollectionMacro: ExtensionMacro, MemberAttributeMacro {
    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingAttributesFor member: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AttributeSyntax] {
        guard let functionDecl = member.as(FunctionDeclSyntax.self) else {
            return []
        }

        let attributes = functionDecl.attributes.compactMap({ $0.as(AttributeSyntax.self) })

        let attribute = attributes.first(where: {
            allowedRouteDecorators.contains($0.attributeName.trimmedDescription)
        })

        guard let attribute else {
            return []
        }

        let routeAttrib = try RouteAttribute(from: attribute, functionName: functionDecl.name)
        print(routeAttrib)

        return [routeAttrib.decorator(context: context)]
    }

    static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        do {
            return try build(
                node: node,
                declaration: declaration,
                type: type,
                protocols: protocols,
                context: context
            )
        } catch {
            context.diagnose(error.diagnostic)
            return []
        }
    }

    static func build(
        node: AttributeSyntax,
        declaration: some DeclGroupSyntax,
        type: some TypeSyntaxProtocol,
        protocols: [TypeSyntax],
        context: some MacroExpansionContext
    ) throws(DiagnosticError) -> [ExtensionDeclSyntax] {
        var body = CodeBlockItemListSyntax()

        for member in declaration.memberBlock.members {
            guard let functionDecl = member.decl.as(FunctionDeclSyntax.self) else {
                continue
            }

            let attribute = functionDecl.attributes
                .compactMap({ $0.as(AttributeSyntax.self) })
                .first(where: { allowedRouteDecorators.contains($0.attributeName.trimmedDescription) })

            guard let attribute else {
                continue
            }

            let routeAttrib = try RouteAttribute(from: attribute, functionName: functionDecl.name)

            var routeCall = functionDecl.call(baseName: "self") {
                LabeledExprSyntax(
                    label: "request",
                    expression: DeclReferenceExprSyntax(baseName: "$0")
                )
            }

            // the route method will throw it has any parameters
            // - if the original method doesnt throw
            // - and it has params
            // -> add throws
            if !functionDecl.canThrow(),
               !functionDecl.signature.parameterClause.parameters.isEmpty {
                routeCall = TryExprSyntax(expression: routeCall)
            }

            let routeFunction = FunctionCallExprSyntax(
                callee: MemberAccessExprSyntax(
                    base: DeclReferenceExprSyntax(baseName: "routes"),
                    name: "on"
                ),
                trailingClosure: ClosureExprSyntax(statementsBuilder: {
                    CodeBlockItemSyntax(item: .expr(.init(routeCall)))
                })
            ) {
                LabeledExprSyntax(expression: routeAttrib.method)
                routeAttrib.path.map({ LabeledExprSyntax(expression: $0) })
            }

            body.append(.init(item: .expr(.init(routeFunction))))
        }

        let bootFunction = FunctionDeclSyntax(
            name: "boot",
            signature: FunctionSignatureSyntax(
                parameterClause: .init(parametersBuilder: {
                    FunctionParameterSyntax(
                        firstName: "routes",
                        type: SomeOrAnyTypeSyntax(
                            someOrAnySpecifier: .keyword(.any),
                            constraint: TypeSyntax("RoutesBuilder"))
                    )
                }),
                effectSpecifiers: .init(throwsClause: .init(throwsSpecifier: .keyword(.throws)))
            ),
            body: .init(statementsBuilder: { body })
        )

        let extensionDecl = ExtensionDeclSyntax(
            extendedType: type,
            inheritanceClause: .init(inheritedTypesBuilder: {
                InheritedTypeSyntax(type: TypeSyntax("RouteCollection"))
            }),
            memberBlockBuilder: { bootFunction }
        )

        return [extensionDecl]
    }

}
