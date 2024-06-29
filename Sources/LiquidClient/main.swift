import Liquid
//import OpenAPIKit

@RouteCollection(prefixed: "greet")
struct Greetings {
    @Route(.GET, "world")
    func greetWorld() -> String {
        "Hello World"
    }

    @GET("greet", ":language", ":name")
    func greetPerson(@Path("language") lang: String, @Path("name") name: String) -> String {
        lang + " " + name
    }
}


let app = try await Application.make(.testing)

let greetings = Greetings()

try app.register(collection: greetings)
//try app.register(collection: <#T##any RouteCollection#>)
try await app.startup()

print(app.routes.all)

let res = app.client.send(.GET, to: "world")


try await Task.sleep(for: .seconds(30))
try await app.asyncShutdown()
