import Testing
import Vapor

extension Tag {
    @Tag static var parameters: Self
}

func withRoutes(of collection: some RouteCollection, perform: (Application) async throws -> Void) async throws {
    let app = try await Application.make(.testing)
    try app.register(collection: collection)

    print(app.routes.all.map(\.path))
    try await perform(app)

    try await app.asyncShutdown()
}
