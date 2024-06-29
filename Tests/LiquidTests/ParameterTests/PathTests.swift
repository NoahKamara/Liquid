import XCTest
import MacroTesting
@testable import LiquidMacros

final class PathTests: XCTestCase {
    override func invokeTest() {
        withMacroTesting(
            macros: [
                "Route": RouteMacro.self
            ]
        ) {
            super.invokeTest()
        }
    }

    func testParameterName() throws {
        assertMacro {
            #"""
            @Route(.GET, "greet", ":name")
            func greet(@Path name: String) -> String {
                "Hello \(name)"
            }
            """#
        } expansion: {
            #"""
            func greet(@Path name: String) -> String {
                "Hello \(name)"
            }

            func greet(request: Request) -> String {
                let __macro_local_4namefMu_ = try RouteParamters.Path("name")
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }

    func testCustomPath() throws {
        assertMacro {
            #"""
            @Route(.GET, "greet", ":name")
            func greet(@Path("person") name: String) -> String {
                "Hello \(name)"
            }
            """#
        } expansion: {
            #"""
            func greet(@Path("person") name: String) -> String {
                "Hello \(name)"
            }

            func greet(request: Request) -> String {
                let __macro_local_4namefMu_ = try RouteParamters.Path("person")
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }
}
