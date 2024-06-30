//import Liquid
//import Testing
//
//
//
//@Suite("Request Query", .tags(.parameters))
//struct QueryParameter {
//    @Test
//    func noParameters() async throws {
//        try await withRoutes(of: PathRoutes()) { app in
//            let res = try await app.get("/greet/world")
//
//            // Request Succeeded
//            #expect(res.status == .ok)
//
//            let content = try res.content.decode(String.self, as: .plainText)
//
//            // Correct Request was called
//            #expect(content == "Hello World")
//        }
//    }
//
//    @Test
//    func inferredParameterName() async throws {
//        try await withRoutes(of: PathRoutes()) { app in
//            let res = try await app.get("/greet/Noah")
//
//            // Request Succeeded
//            #expect(res.status == .ok)
//
//            let content = try res.content.decode(String.self, as: .plainText)
//
//            // Correct Request was called
//            #expect(content == "Hello Noah")
//        }
//    }
//
//    @Test(arguments: [Language.german, .spanish])
//    func aliasParameter(lang: Language) async throws {
//        try await withRoutes(of: PathRoutes()) { app in
//            let res = try await app.get("/\(lang)/greet")
//
//            // Request Succeeded
//            #expect(res.status == .ok)
//
//            let content = try res.content.decode(String.self, as: .plainText)
//
//            // Correct Request was called
//            #expect(content == lang.greeting)
//        }
//    }
//
//    @Test(arguments: [
//        "Users",
//        "Users/noahkamara"
//    ])
//    func testCatchAll(path: String) async throws {
//        try await withRoutes(of: PathRoutes()) { app in
//            let res = try await app.get("/file/\(path)")
//
//            // Request Succeeded
//            #expect(res.status == .ok)
//
//            let content = try res.content.decode(String.self, as: .plainText)
//
//            // Correct Request was called
//            #expect(content == path)
//        }
//    }
//}
//
//@RouteCollection
//fileprivate struct QueryRoutes {
//    @GET("greet")
//    func greetPerson(@Query name: String) -> String {
//        "Hello \(name)"
//    }
//
//    @GET(":lang", "greet")
//    func greetLocalized(@Path("lang") language: Language) -> String {
//        language.greeting
//    }
//
//    @GET("file", "**")
//    func file(@Path(.catchall) path: [String]) -> String {
//        path.joined(separator: "/")
//    }
//}
