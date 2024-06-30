import XCTest
import MacroTesting
@testable import LiquidMacros

final class HeaderTests: XCTestCase {
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
            func greet(@Header name: String) -> String {
                "Hello \(name)"
            }
            """#
        } expansion: {
            #"""
            func greet(@Header name: String) -> String {
                "Hello \(name)"
            }

            func greet(request: Request) throws -> String {
                let __macro_local_4namefMu_ = try RouteParameters.Header(String.self, "name")(from: request)
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }

    func testCustomName() throws {
        assertMacro {
            #"""
            @CollectableRoute(.GET, "greet", ":name")
            func greet(@Header("person") name: String) -> String {
                "Hello \(name)"
            }
            """#
        } expansion: {
            #"""
            func greet(@Header("person") name: String) -> String {
                "Hello \(name)"
            }

            func greet(request: Request) throws -> String {
                let __macro_local_4namefMu_ = try RouteParameters.Header(String.self, "person")(from: request)
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }
}
