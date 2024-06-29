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
                @CollectableRoute(.GET, "greet")
                func greet() -> String { "Hello World" }
            }

            extension Greetings: RouteCollection {
                func boot(routes: any RoutesBuilder) throws {
                    routes.on(.GET, "greet", use: {
                            self.greet(request: $0)
                        })
                }
            }
            """
        }
    }

    func testRootPath() throws {
        assertMacro {
            """
            @RouteCollection
            struct Greetings {
                @GET("/")
                func greet() -> String { "Hello World" }
            }
            """
        } expansion: {
            """
            struct Greetings {
                @GET("/")
                @CollectableRoute(.GET, "/")
                func greet() -> String { "Hello World" }
            }

            extension Greetings: RouteCollection {
                func boot(routes: any RoutesBuilder) throws {
                    routes.on(.GET, "/", use: {
                            self.greet(request: $0)
                        })
                }
            }
            """
        }
    }

    func testPathConstants() throws {
        assertMacro {
            """
            @RouteCollection
            struct Greetings {
                @GET("greet", "world")
                func greet() -> String { "Hello World" }
            }
            """
        } expansion: {
            """
            struct Greetings {
                @GET("greet", "world")
                @CollectableRoute(.GET, "greet", "world")
                func greet() -> String { "Hello World" }
            }

            extension Greetings: RouteCollection {
                func boot(routes: any RoutesBuilder) throws {
                    routes.on(.GET, "greet", "world", use: {
                            self.greet(request: $0)
                        })
                }
            }
            """
        }
    }

    func testPathParameters() throws {
        assertMacro {
            """
            @RouteCollection
            struct Greetings {
                @GET("greet", ":name")
                func greet(name: String) -> String { "Hello \\(name)" }
            }
            """
        } expansion: {
            """
            struct Greetings {
                @GET("greet", ":name")
                @CollectableRoute(.GET, "greet", ":name")
                func greet(name: String) -> String { "Hello \\(name)" }
            }

            extension Greetings: RouteCollection {
                func boot(routes: any RoutesBuilder) throws {
                    routes.on(.GET, "greet", ":name", use: {
                            self.greet(request: $0)
                        })
                }
            }
            """
        }
    }

    func testPathAnything() throws {
        assertMacro {
            """
            @RouteCollection
            struct Greetings {
                @GET("greet", "*")
                func greet() -> String { "Hello There" }
            }
            """
        } expansion: {
            """
            struct Greetings {
                @GET("greet", "*")
                @CollectableRoute(.GET, "greet", "*")
                func greet() -> String { "Hello There" }
            }

            extension Greetings: RouteCollection {
                func boot(routes: any RoutesBuilder) throws {
                    routes.on(.GET, "greet", "*", use: {
                            self.greet(request: $0)
                        })
                }
            }
            """
        }
    }

    func testPathCatchall() throws {
        assertMacro {
            """
            @RouteCollection
            struct Greetings {
                @GET("greet", "**")
                func greet() -> String { "Hello There" }
            }
            """
        } expansion: {
            """
            struct Greetings {
                @GET("greet", "**")
                @CollectableRoute(.GET, "greet", "**")
                func greet() -> String { "Hello There" }
            }

            extension Greetings: RouteCollection {
                func boot(routes: any RoutesBuilder) throws {
                    routes.on(.GET, "greet", "**", use: {
                            self.greet(request: $0)
                        })
                }
            }
            """
        }
    }
}
