import XCTest
import MacroTesting
@testable import LiquidMacros


final class QueryTests: XCTestCase {
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
        XCTFail()
        assertMacro {
            #"""
            @CollectableRoute(.GET, "greet")
            func greet(@Query(.container) name: String) -> String {
                "Hello \(name)"
            }
            """#
        } expansion: {
            #"""
            func greet(@Query(.container) name: String) -> String {
                "Hello \(name)"
            }

            func greet(request: Request) throws -> String {
                let __macro_local_4namefMu_ = try RouteParameters.Query(String.self, .container)(from: request)
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }

    func testParameterName() throws {
        assertMacro {
            #"""
            @CollectableRoute(.GET, "greet")
            func greet(@Query name: String) -> String {
                "Hello \(name)"
            }
            """#
        } expansion: {
            #"""
            func greet(@Query name: String) -> String {
                "Hello \(name)"
            }

            func greet(request: Request) throws -> String {
                let __macro_local_4namefMu_ = try RouteParameters.Query(String.self, "name")(from: request)
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }

    func testCustomPath() throws {
        assertMacro {
            #"""
            @CollectableRoute(.GET, "greet")
            func greet(@Query("person") name: String) -> String {
                "Hello \(name)"
            }
            """#
        } expansion: {
            #"""
            func greet(@Query("person") name: String) -> String {
                "Hello \(name)"
            }

            func greet(request: Request) throws -> String {
                let __macro_local_4namefMu_ = try RouteParameters.Query(String.self, "person")(from: request)
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }

    func testCustomMultiPath() throws {
        assertMacro {
            #"""
            @CollectableRoute(.GET, "greet")
            func greet(@Query("person", "name") name: String) -> String {
                "Hello \(name)"
            }
            """#
        } expansion: {
            #"""
            func greet(@Query("person", "name") name: String) -> String {
                "Hello \(name)"
            }

            func greet(request: Request) throws -> String {
                let __macro_local_4namefMu_ = try RouteParameters.Query(String.self, "person", "name")(from: request)
                return greet(name: __macro_local_4namefMu_)
            }
            """#
        }
    }
}

