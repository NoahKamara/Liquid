import XCTest
import MacroTesting
@testable import LiquidMacros

final class BodyTests: XCTestCase {
    override func invokeTest() {
        withMacroTesting(
            macros: [
                "Route": RouteMacro.self
            ]
        ) {
            super.invokeTest()
        }
    }

    func testContainer() throws {
        XCTExpectFailure("Not Implemented")

        assertMacro {
            #"""
            @Route(.POST, "greet")
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
                let __macro_local_4namefMu_ = try RouteParamters.Body()
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }

    func testParameterName() throws {
        assertMacro {
            #"""
            @Route(.POST, "greet")
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
                let __macro_local_4namefMu_ = try RouteParamters.Body("name")
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }

    func testCustomPath() throws {
        assertMacro {
            #"""
            @Route(.POST, "greet")
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
                let __macro_local_4namefMu_ = try RouteParamters.Body("person")
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }

    func testCustomMultiPath() throws {
        assertMacro {
            #"""
            @Route(.POST, "greet")
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
                let __macro_local_4namefMu_ = try RouteParamters.Body("person", "name")
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }
}

