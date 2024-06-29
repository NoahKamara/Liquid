import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftData


@main
struct LiquidPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        RouteMacro.self,
        RouteCollectionMacro.self,
        DecoratorMacro.self
    ]
}

struct DecoratorMacro: PeerMacro {
    static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        return []
    }
}
