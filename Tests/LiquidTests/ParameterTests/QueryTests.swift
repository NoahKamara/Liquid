import XCTest
import MacroTesting
@testable import LiquidMacros

final class QueryTests: XCTestCase {
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
            @Route(.GET, "greet")
            func greet(@Query(.container) name: String) -> String {
                "Hello \(name)"
            }
            """#
        } expansion: {
            #"""
            func greet(@Query(.container) name: String) -> String {
                "Hello \(name)"
            }

            func greet(request: Request) -> String {
                let __macro_local_4namefMu_ = try RouteParamters.Query()
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }

    func testParameterName() throws {
        assertMacro {
            #"""
            @Route(.GET, "greet")
            func greet(@Query name: String) -> String {
                "Hello \(name)"
            }
            """#
        } expansion: {
            #"""
            func greet(@Query name: String) -> String {
                "Hello \(name)"
            }

            func greet(request: Request) -> String {
                let __macro_local_4namefMu_ = try RouteParamters.Query("name")
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }

    func testCustomPath() throws {
        assertMacro {
            #"""
            @Route(.GET, "greet")
            func greet(@Query("person") name: String) -> String {
                "Hello \(name)"
            }
            """#
        } expansion: {
            #"""
            func greet(@Query("person") name: String) -> String {
                "Hello \(name)"
            }

            func greet(request: Request) -> String {
                let __macro_local_4namefMu_ = try RouteParamters.Query("person")
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }

    func testCustomMultiPath() throws {
        assertMacro {
            #"""
            @Route(.GET, "greet")
            func greet(@Query("person", "name") name: String) -> String {
                "Hello \(name)"
            }
            """#
        } expansion: {
            #"""
            func greet(@Query("person", "name") name: String) -> String {
                "Hello \(name)"
            }

            func greet(request: Request) -> String {
                let __macro_local_4namefMu_ = try RouteParamters.Query("person", "name")
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }
}

