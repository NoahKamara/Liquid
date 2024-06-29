import Liquid
import Testing


@Suite
struct RouteE2E {
    @Test("HTTP Methods", arguments: [
        "GET", "PUT", "ACL", "HEAD", "POST", "COPY",
        "LOCK", "MOVE", "BIND", "LINK", "PATCH", "TRACE",
        "MKCOL", "MERGE", "PURGE", "NOTIFY", "SEARCH", 
        "UNLOCK", "REBIND", "UNBIND", "REPORT", "DELETE",
        "UNLINK", "CONNECT", "MSEARCH", "OPTIONS", "PROPFIND", 
        "CHECKOUT", "PROPPATCH", "SUBSCRIBE", "MKCALENDAR",
        "MKACTIVITY", "UNSUBSCRIBE", "SOURCE"
    ])
    func methods(method: String) async throws {
        try await withRoutes(of: MethodTestingRoutes()) { app in
            // Route with method exists
            try #require(app.routes.all.contains(where: {
                $0.path.first?.description == method && $0.method.rawValue == method
            }))

            let res = try await app.send(.init(rawValue: method), "/"+method)

            // Request Succeeded
            #expect(res.status == .ok)

            // Correct Request was called
            #expect(try res.content.decode(String.self, as: .plainText) == method)
        }
    }
}


@RouteCollection
struct MethodTestingRoutes {
    @GET("GET")
    func GET() -> String { "GET" }

    @PUT("PUT")
    func PUT() -> String { "PUT" }

    @ACL("ACL")
    func ACL() -> String { "ACL" }

    @HEAD("HEAD")
    func HEAD() -> String { "HEAD" }

    @POST("POST")
    func POST() -> String { "POST" }

    @COPY("COPY")
    func COPY() -> String { "COPY" }

    @LOCK("LOCK")
    func LOCK() -> String { "LOCK" }

    @MOVE("MOVE")
    func MOVE() -> String { "MOVE" }

    @BIND("BIND")
    func BIND() -> String { "BIND" }

    @LINK("LINK")
    func LINK() -> String { "LINK" }

    @PATCH("PATCH")
    func PATCH() -> String { "PATCH" }

    @TRACE("TRACE")
    func TRACE() -> String { "TRACE" }

    @MKCOL("MKCOL")
    func MKCOL() -> String { "MKCOL" }

    @MERGE("MERGE")
    func MERGE() -> String { "MERGE" }

    @PURGE("PURGE")
    func PURGE() -> String { "PURGE" }

    @NOTIFY("NOTIFY")
    func NOTIFY() -> String { "NOTIFY" }

    @SEARCH("SEARCH")
    func SEARCH() -> String { "SEARCH" }

    @UNLOCK("UNLOCK")
    func UNLOCK() -> String { "UNLOCK" }

    @REBIND("REBIND")
    func REBIND() -> String { "REBIND" }

    @UNBIND("UNBIND")
    func UNBIND() -> String { "UNBIND" }

    @REPORT("REPORT")
    func REPORT() -> String { "REPORT" }

    @DELETE("DELETE")
    func DELETE() -> String { "DELETE" }

    @UNLINK("UNLINK")
    func UNLINK() -> String { "UNLINK" }

    @CONNECT("CONNECT")
    func CONNECT() -> String { "CONNECT" }

    @MSEARCH("MSEARCH")
    func MSEARCH() -> String { "MSEARCH" }

    @OPTIONS("OPTIONS")
    func OPTIONS() -> String { "OPTIONS" }

    @PROPFIND("PROPFIND")
    func PROPFIND() -> String { "PROPFIND" }

    @CHECKOUT("CHECKOUT")
    func CHECKOUT() -> String { "CHECKOUT" }

    @PROPPATCH("PROPPATCH")
    func PROPPATCH() -> String { "PROPPATCH" }

    @SUBSCRIBE("SUBSCRIBE")
    func SUBSCRIBE() -> String { "SUBSCRIBE" }

    @MKCALENDAR("MKCALENDAR")
    func MKCALENDAR() -> String { "MKCALENDAR" }

    @MKACTIVITY("MKACTIVITY")
    func MKACTIVITY() -> String { "MKACTIVITY" }

    @UNSUBSCRIBE("UNSUBSCRIBE")
    func UNSUBSCRIBE() -> String { "UNSUBSCRIBE" }

    @SOURCE("SOURCE")
    func SOURCE() -> String { "SOURCE" }
}

