import XCTest
import MacroTesting
@testable import LiquidMacros




final class RouteCollectionTests: XCTestCase {
    let expansion = """
    func greet() -> String {
        "Hello World"
    }

    func greet(request: Request) -> String {
        return greet()
    }
    """

    override func invokeTest() {
        withMacroTesting(
            macros: [
                "RouteCollection": RouteCollectionMacro.self,
            ]
        ) {
            super.invokeTest()
        }
    }

//    func testEmpty() throws {
//        assertMacro {
//            """
//            @RouteCollection
//            struct Greetings {}
//            """
//        } expansion: {
//            """
//            struct Greetings {}
//            
//            extension Greetings: RouteCollection {
//                func boot(routes: any RoutesBuilder) throws {
//                }
//            }
//            """
//        }
//    }

    func testInferredPath() throws {
        assertMacro {
            """
            @RouteCollection
            struct Greetings {
                @GET
                func greet() -> String { "Hello World" }
            }
            """
        } expansion: {
            """
            struct Greetings {
                @GET
                @CollectableRoute(.GET, "greet", use: __macro_local_9_GETgreetfMu_)
                func greet() -> String { "Hello World" }
            }

            extension Greetings: RouteCollection {
                func boot(routes: any RoutesBuilder) throws {
                    routes.on(.GET, "greet", use: {
                            self.__macro_local_5greetfMu_(route: $0)
                        })
                }
            }
            """
        }
    }

//    func testRootPath() throws {
//        assertMacro {
//            """
//            @RouteCollection
//            struct Greetings {
//                @GET("/")
//                func greet() -> String { "Hello World" }
//            }
//            """
//        } expansion: {
//            """
//            struct Greetings {
//                @GET("/")
//                @CollectableRoute(.GET, "/")
//                func greet() -> String { "Hello World" }
//            }
//
//            extension Greetings: RouteCollection {
//                func boot(routes: any RoutesBuilder) throws {
//                    routes.on(.GET, "/", use: {
//                            self.__macro_local_5greetfMu_(route: $0)
//                        })
//                }
//            }
//            """
//        }
//    }
}
