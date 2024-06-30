import Liquid
//import OpenAPIKit


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

@RouteCollection(prefixed: "greet")
struct Greetings {
    @GET("greet", ":language", ":name")
    func greet(
        @Path name: String,
        @Path("language") lang: Language
    ) -> String {
        lang.greeting + " " + name
    }

    struct FileInfo: Content {
        let name: String
        let path: String
    }

    @GET("files", .catchall)
    func getFileInfo(
        @Path(.catchall) filePath: [String]
    ) throws -> FileInfo {
        guard let name = filePath.last else {
            throw Abort(.notFound, reason: "File does not exist")
        }

        return FileInfo(name: name, path: filePath.joined(separator: "/"))
    }
}


let app = try await Application.make(.testing)

let greetings = Greetings()

try app.register(collection: greetings)
try await app.startup()

print(app.routes.all)

let res = app.client.send(.GET, to: "world")


try await Task.sleep(for: .seconds(30))
try await app.asyncShutdown()
