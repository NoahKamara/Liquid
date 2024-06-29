@testable import Liquid
import Testing

extension RawRepresentable where Self: LosslessStringConvertible, RawValue == String {
    public var description: String { rawValue }

    public init?(_ description: String) {
        self.init(rawValue: description)
    }
}

enum Language: String, LosslessStringConvertible {
    case german = "de"
    case spanish = "en"

    var greeting: String {
        switch self {
            case .german: "Hallo"
            case .spanish: "Hola"
        }
    }
}

@Suite("Parameter: Path", .tags(.parameters))
struct PathParameter {
    @RouteCollection
    struct PathParameterRoutes {
        @GET("greet", ":language", ":name")
        func greetPerson(@Path("language") lang: Language, @Path(.anything) name: String) -> String {
            lang.greeting + " " + name
        }

        @GET("greetCustomName", ":name")
        func greetCustomName(@Path("name") customName: String) -> String {
            "Hello \(customName)"
        }
    }

    @Test("Inferred Name", arguments: [Language.german, .spanish], ["Noah", "Georgina"])
    func parameterName(language: Language, name: String) async throws {
        try await withRoutes(of: PathParameterRoutes()) { app in
            let res = try await app.send(.GET, "/greet", language.rawValue, name) {
                #expect($0.url.path == "/greet/\(language.rawValue)/\(name)")
            }

            #expect(res.status == .ok)

            let content = try res.content.decode(String.self, as: .plainText)
            let expectedContent = language.greeting+" "+name
            #expect(content == expectedContent)
        }
    }

    func testCustomName() async throws {
        try await withRoutes(of: PathParameterRoutes()) { app in
            let res = try await app.send(.GET, "/greetCustomName", "Noah")

            // Request Succeeded
            #expect(res.status == .ok)

            // Correct Request was called
            #expect(try res.content.decode(String.self, as: .plainText) == "Hello Noah")
        }
    }
}


