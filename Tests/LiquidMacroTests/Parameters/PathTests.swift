import XCTest
import MacroTesting
@testable import LiquidMacros

final class PathTests: XCTestCase {
    override func invokeTest() {
        withMacroTesting(
            macros: [
                "CollectableRoute": RouteMacro.self
            ]
        ) {
            super.invokeTest()
        }
    }

    func testParameterName() throws {
        assertMacro {
            #"""
            @CollectableRoute(.GET, "greet", ":name")
            func greet(@Path name: String) -> String {
                "Hello \(name)"
            }
            """#
        } expansion: {
            #"""
            func greet(@Path name: String) -> String {
                "Hello \(name)"
            }

            func greet(request: Request) throws -> String {
                let __macro_local_4namefMu_ = try RouteParameters.Path(String.self, "name")(from: request)
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }

    func testCustomPath() throws {
        assertMacro {
            #"""
            @CollectableRoute(.GET, "greet", ":name")
            func greet(@Path("person") name: String) -> String {
                "Hello \(name)"
            }
            """#
        } expansion: {
            #"""
            func greet(@Path("person") name: String) -> String {
                "Hello \(name)"
            }

            func greet(request: Request) throws -> String {
                let __macro_local_4namefMu_ = try RouteParameters.Path(String.self, "person")(from: request)
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }
}
