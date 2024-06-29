import Vapor
@_exported import Vapor

struct T: RouteCollection {
    func greet(request: Request) -> String {
        "Hello World"
    }
    
    func boot(routes: any RoutesBuilder) throws {
        routes.on(.GET, use: self.greet)
    }
}
