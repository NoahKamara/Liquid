import XCTest
import MacroTesting
@testable import LiquidMacros

final class HeaderTests: XCTestCase {
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
            func greet(@Header name: String) -> String {
                "Hello \(name)"
            }
            """#
        } expansion: {
            #"""
            func greet(@Header name: String) -> String {
                "Hello \(name)"
            }

            func greet(request: Request) -> String {
                let __macro_local_4namefMu_ = try RouteParamters.Header("name")
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }

    func testCustomName() throws {
        assertMacro {
            #"""
            @Route(.GET, "greet", ":name")
            func greet(@Header("person") name: String) -> String {
                "Hello \(name)"
            }
            """#
        } expansion: {
            #"""
            func greet(@Header("person") name: String) -> String {
                "Hello \(name)"
            }

            func greet(request: Request) -> String {
                let __macro_local_4namefMu_ = try RouteParamters.Header("person")
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }
}
