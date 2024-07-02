import Liquid
import Testing



@Suite("Request Query", .tags(.parameters))
struct QueryParameter {
    @Test
    func noParameters() async throws {
        try await withRoutes(of: QueryRoutes()) { app in
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
        try await withRoutes(of: QueryRoutes()) { app in
            let res = try await app.send(.GET, "/greet", parameters: ("name", "Noah"))

            // Request Succeeded
            #expect(res.status == .ok)

            let content = try res.content.decode(String.self, as: .plainText)

            // Correct Request was called
            #expect(content == "Hello Noah")
        }
    }

    @Test(arguments: [Language.german, .spanish])
    func aliasParameter(lang: Language) async throws {
        try await withRoutes(of: QueryRoutes()) { app in
            let res = try await app.get("/int/greet", parameters: ("lang", lang))

            // Request Succeeded
            #expect(res.status == .ok)

            let content = try res.content.decode(String.self, as: .plainText)

            // Correct Request was called
            #expect(content == lang.greeting)
        }
    }

    @Test(arguments: ["No No It's not true, thats impossible"], [Casing.uppercase, Casing.lowercase, nil])
    func optional(text: String, casing: Casing?) async throws {
        try await withRoutes(of: QueryRoutes()) { app in

            var parameters = [("text", text)]
            if let casing {
                parameters.append(("case", casing.rawValue))
            }

            let res = try await app.get("/echo", parameters: parameters)

            // Request Succeeded
            #expect(res.status == .ok)

            let content = try res.content.decode(String.self)

            // Correct Request was called
            switch casing {
                case .uppercase:
                    #expect(content == "NO NO IT'S NOT TRUE, THATS IMPOSSIBLE")
                case .lowercase:
                    #expect(content == "no no it's not true, thats impossible")
                case .none:
                    #expect(content == text)
            }
        }
    }

    @Test(arguments: ["Hello", nil])
    func defaultValue(text: String?) async throws {
        try await withRoutes(of: QueryRoutes()) { app in
            let res = try await app.get("/default", parameters: text.map({ [("text", $0)] }) ?? [])

            // Request Succeeded
            #expect(res.status == .ok)

            let content = try res.content.decode(String.self)

            #expect(content == (text ?? "Lorem Ipsum"))
        }
    }
}

@RouteCollection
fileprivate struct QueryRoutes {
    @GET("greet", "world")
    func greetWorld() -> String {
        "Hello World"
    }

    @GET("greet")
    func greetPerson(@Query name: String) -> String {
        "Hello \(name)"
    }

    @GET("int", "greet")
    func greetLocalized(@Query("lang") language: Language) -> String {
        language.greeting
    }

    @GET("echo")
    func echo(@Query("text") text: String, @Query("case") casing: Casing?) -> String {
        return casing?.apply(to: text) ?? text
    }

    @GET("default")
    func defaultValue(@Query("text") text: String = "Lorem Ipsum") -> String {
        return text
    }
}
