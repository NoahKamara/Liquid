import Liquid
import Testing


enum Language: String, Codable, LosslessStringConvertible {
    case german = "de"
    case spanish = "en"

    var greeting: String {
        switch self {
            case .german: "Hallo"
            case .spanish: "Hola"
        }
    }
}


@Suite("Request Path", .tags(.parameters))
struct PathParameterTests {
    @Test
    func noParameters() async throws {
        try await withRoutes(of: PathRoutes()) { app in
            let res = try await app.get("/greet/world")

            // Request Succeeded
            #expect(res.status == .ok)

            let content = try res.content.decode(String.self, as: .plainText)

            // Correct Request was called
            #expect(content == "Hello World")
        }
    }
    
    @Test
    func inferredParameterName() async throws {
        try await withRoutes(of: PathRoutes()) { app in
            let res = try await app.get("/greet/Noah")

            // Request Succeeded
            #expect(res.status == .ok)

            let content = try res.content.decode(String.self, as: .plainText)

            // Correct Request was called
            #expect(content == "Hello Noah")
        }
    }

    @Test(arguments: [Language.german, .spanish])
    func aliasParameter(lang: Language) async throws {
        try await withRoutes(of: PathRoutes()) { app in
            let res = try await app.get("/\(lang)/greet")

            // Request Succeeded
            #expect(res.status == .ok)

            let content = try res.content.decode(String.self, as: .plainText)

            // Correct Request was called
            #expect(content == lang.greeting)
        }
    }

    @Test(arguments: [
        "Users",
        "Users/noahkamara"
    ])
    func testCatchAll(path: String) async throws {
        try await withRoutes(of: PathRoutes()) { app in
            let res = try await app.get("/file/\(path)")

            // Request Succeeded
            #expect(res.status == .ok)
            
            let content = try res.content.decode(String.self, as: .plainText)

            // Correct Request was called
            #expect(content == path)
        }
    }

    @Test(arguments: ["No No It's not true, thats impossible"], [Casing.uppercase, Casing.lowercase])
    func testStringLiteral(text: String, casing: Casing) async throws {
        try await withRoutes(of: PathRoutes()) { app in
            let res = try await app.get("/case/\(casing)/\(text)")

            // Request Succeeded
            #expect(res.status == .ok)

            let content = try res.content.decode(String.self)

            // Correct Request was called
            switch casing {
                case .uppercase:
                    #expect(content == "NO NO IT'S NOT TRUE, THATS IMPOSSIBLE")
                case .lowercase:
                    #expect(content == "no no it's not true, thats impossible")
            }
        }
    }
}


enum Casing: String, LosslessStringConvertible, Codable {
    case uppercase = "upper"
    case lowercase = "lower"

    func apply(to text: String) -> String {
        switch self {
            case .uppercase: text.uppercased()
            case .lowercase: text.lowercased()
        }
    }
}

@RouteCollection
fileprivate struct PathRoutes {
    @GET("greet", "world")
    func greetWorld() -> String {
        "Hello World"
    }

    @GET("greet", ":name")
    func greetPerson(@Path name: String) -> String {
        "Hello \(name)"
    }

    @GET(":lang", "greet")
    func greetLocalized(@Path("lang") language: Language) -> String {
        language.greeting
    }

    @GET("case", ":case", ":text")
    func changeCase(@Path("case") casing: Casing, @Path("text") text: String) -> String {
        return casing.apply(to: text)
    }

    @GET("file", "**")
    func file(@Path(.catchall) path: [String]) -> String {
        path.joined(separator: "/")
    }
}
