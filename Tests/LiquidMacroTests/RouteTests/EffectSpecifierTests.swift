import XCTest
import MacroTesting
@testable import LiquidMacros

final class EffectSpecifierTests: XCTestCase {
    override func invokeTest() {
        withMacroTesting(
            macros: [
                "RouteCollection": RouteCollectionMacro.self,
                "CollectableRoute": RouteMacro.self
            ]
        ) {
            super.invokeTest()
        }
    }

    func testNoSpecifier() throws {
        assertMacro {
            #"""
            @RouteCollection
            struct Greetings {
                @GET("greet")
                func greet() -> String {
                    "Hello World"
                }
            }
            """#
        } expansion: {
            """
            struct Greetings {
                @GET("greet")
                func greet() -> String {
                    "Hello World"
                }

                func greet(request: Request) -> String {
                    return greet()
                }
            }

            extension Greetings: RouteCollection {
                func boot(routes: any RoutesBuilder) throws {
                    routes.on(.GET, "greet") {
                        self.greet(request: $0)
                    }
                }
            }
            """
        }
    }

    func testNoSpecifierButParameters() throws {
        assertMacro {
            #"""
            @RouteCollection
            struct Greetings {
                @GET("greet")
                func greet(@Query name: String) -> String {
                    "Hello \(name)"
                }
            }
            """#
        } expansion: {
            #"""
            struct Greetings {
                @GET("greet")
                func greet(@Query name: String) -> String {
                    "Hello \(name)"
                }

                func greet(request: Request) throws -> String {
                    let __macro_local_4namefMu_ = try RouteParameters.Query(String.self, "name")(from: request)
                    return greet(name: __macro_local_4namefMu_)
                }
            }

            extension Greetings: RouteCollection {
                func boot(routes: any RoutesBuilder) throws {
                    routes.on(.GET, "greet") {
                        try self.greet(request: $0)
                    }
                }
            }
            """#
        }
    }

    func testThrows() throws {
        assertMacro {
            #"""
            @RouteCollection
            struct Greetings {
                @GET("greet")
                func greet() throws -> String {
                    "Hello World"
                }
            }
            """#
        } expansion: {
            """
            struct Greetings {
                @GET("greet")
                func greet() throws -> String {
                    "Hello World"
                }

                func greet(request: Request) throws -> String {
                    return try greet()
                }
            }

            extension Greetings: RouteCollection {
                func boot(routes: any RoutesBuilder) throws {
                    routes.on(.GET, "greet") {
                        try self.greet(request: $0)
                    }
                }
            }
            """
        }
    }

    func testAsync() throws {
        assertMacro {
            #"""
            @RouteCollection
            struct Greetings {
                @GET("greet")
                func greet() async -> String {
                    "Hello World"
                }
            }
            """#
        } expansion: {
            """
            struct Greetings {
                @GET("greet")
                func greet() async -> String {
                    "Hello World"
                }

                func greet(request: Request) async -> String {
                    return await greet()
                }
            }

            extension Greetings: RouteCollection {
                func boot(routes: any RoutesBuilder) throws {
                    routes.on(.GET, "greet") {
                        await self.greet(request: $0)
                    }
                }
            }
            """
        }
    }

    func testAsyncThrows() throws {
        assertMacro {
            #"""
            @RouteCollection
            struct Greetings {
                @GET("greet")
                func greet() async throws -> String {
                    "Hello World"
                }
            }
            """#
        } expansion: {
            """
            struct Greetings {
                @GET("greet")
                func greet() async throws -> String {
                    "Hello World"
                }

                func greet(request: Request) async throws -> String {
                    return try await greet()
                }
            }

            extension Greetings: RouteCollection {
                func boot(routes: any RoutesBuilder) throws {
                    routes.on(.GET, "greet") {
                        try await self.greet(request: $0)
                    }
                }
            }
            """
        }
    }
}

