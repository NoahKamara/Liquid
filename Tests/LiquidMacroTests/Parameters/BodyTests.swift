import XCTest
import MacroTesting
@testable import LiquidMacros

final class BodyTests: XCTestCase {
    override func invokeTest() {
        withMacroTesting(
            macros: [
                "CollectableRoute": RouteMacro.self
            ]
        ) {
            super.invokeTest()
        }
    }

    func testContainer() throws {
        XCTExpectFailure("Not Implemented")

        assertMacro {
            #"""
            @CollectableRoute(.POST, "greet")
            func greet(@Body(.container) name: String) -> String {
                "Hello \(name)"
            }
            """#
        } expansion: {
            #"""
            func greet(@Body(.container) name: String) -> String {
                "Hello \(name)"
            }

            func greet(request: Request) -> String {
                let __macro_local_4namefMu_ = try RouteParameters.Body()
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }

    func testParameterName() throws {
        assertMacro {
            #"""
            @CollectableRoute(.POST, "greet")
            func greet(@Body name: String) -> String {
                "Hello \(name)"
            }
            """#
        } expansion: {
            #"""
            func greet(@Body name: String) -> String {
                "Hello \(name)"
            }

            func greet(request: Request) -> String {
                let __macro_local_4namefMu_ = try RouteParameters.Body("name")
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }

    func testCustomPath() throws {
        assertMacro {
            #"""
            @CollectableRoute(.POST, "greet")
            func greet(@Body("person") name: String) -> String {
                "Hello \(name)"
            }
            """#
        } expansion: {
            #"""
            func greet(@Body("person") name: String) -> String {
                "Hello \(name)"
            }

            func greet(request: Request) -> String {
                let __macro_local_4namefMu_ = try RouteParameters.Body("person")
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }

    func testCustomMultiPath() throws {
        assertMacro {
            #"""
            @CollectableRoute(.POST, "greet")
            func greet(@Body("person", "name") name: String) -> String {
                "Hello \(name)"
            }
            """#
        } expansion: {
            #"""
            func greet(@Body("person", "name") name: String) -> String {
                "Hello \(name)"
            }

            func greet(request: Request) -> String {
                let __macro_local_4namefMu_ = try RouteParameters.Body("person", "name")
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }
}

