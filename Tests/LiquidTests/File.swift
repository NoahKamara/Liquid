//@testable import Liquid
//import Testing
//
//extension RawRepresentable where Self: LosslessStringConvertible, RawValue == String {
//    public var description: String { rawValue }
//
//    public init?(_ description: String) {
//        self.init(rawValue: description)
//    }
//}
//
//enum Language: String, LosslessStringConvertible {
//    case german = "de"
//    case spanish = "en"
//
//    var greeting: String {
//        switch self {
//            case .german: "Hallo"
//            case .spanish: "Hola"
//        }
//    }
//}
//
//@Suite("Parameter: Path", .tags(.parameters))
//struct PathParameter {
//    @RouteCollection
//    struct PathParameterRoutes {
//        @GET("greet", ":language", ":name")
//        func greet(
//            @Path name: String,
//            @Path("language") lang: Language
//        ) -> String {
//            lang.greeting + " " + name
//        }
//
//        struct FileInfo: Codable {
//            let name: String
//            let path: String
//        }
//
//        @GET("files", .catchall)
//        func getFileInfo(
//            @Path(.catchall) filePath: [String]
//        ) throws -> FileInfo {
//            guard let name = filePath.last else {
//                throw Abort(.notFound, reason: "File does not exist")
//            }
//
//            return FileInfo(name: name, path: filePath.joined(separator: "/"))
//        }
//    }
//
//    @Test("Inferred Name", arguments: ["Noah", "Georgina"], [Language.german, .spanish])
//    func parametrizedPath(name: String, language: Language) async throws {
//        try await withRoutes(of: PathParameterRoutes()) { app in
//            let name = "Noah"
//            let expectedContent = "\(language.greeting) \(name)"
//
//            let res = try await app.send(.GET, "/greet/\(language.rawValue)/\(name)")
//
//            #expect(res.status == .ok)
//
//            let content = try res.content.decode(String.self, as: .plainText)
//            #expect(content == expectedContent)
//        }
//    }
//
//    func testCustomName() async throws {
//        try await withRoutes(of: PathParameterRoutes()) { app in
//            let res = try await app.send(.GET, "/greetCustomName", "Noah")
//
//            // Request Succeeded
//            #expect(res.status == .ok)
//
//            // Correct Request was called
//            #expect(try res.content.decode(String.self, as: .plainText) == "Hello Noah")
//        }
//    }
//}
//
//
