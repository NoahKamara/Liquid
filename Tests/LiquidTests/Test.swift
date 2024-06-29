//import Liquid
//import Testing
//
//enum Language: String {
//    case german = "de"
//    case spanish = "en"
//}
//
//@RouteCollection
//struct MethodTestingRoutes {
////    @GET("GET")
////    func GET() -> String { "GET" }
////    
////    @PUT("PUT")
////    func PUT() -> String { "PUT" }
////    
////    @ACL("ACL")
////    func ACL() -> String { "ACL" }
////    
////    @HEAD("HEAD")
////    func HEAD() -> String { "HEAD" }
////    
////    @POST("POST")
////    func POST() -> String { "POST" }
////    
////    @COPY("COPY")
////    func COPY() -> String { "COPY" }
////    
////    @LOCK("LOCK")
////    func LOCK() -> String { "LOCK" }
////    
////    @MOVE("MOVE")
////    func MOVE() -> String { "MOVE" }
////    
////    @BIND("BIND")
////    func BIND() -> String { "BIND" }
////    
////    @LINK("LINK")
////    func LINK() -> String { "LINK" }
////    
////    @PATCH("PATCH")
////    func PATCH() -> String { "PATCH" }
////    
////    @TRACE("TRACE")
////    func TRACE() -> String { "TRACE" }
////    
////    @MKCOL("MKCOL")
////    func MKCOL() -> String { "MKCOL" }
////    
////    @MERGE("MERGE")
////    func MERGE() -> String { "MERGE" }
////    
////    @PURGE("PURGE")
////    func PURGE() -> String { "PURGE" }
////    
////    @NOTIFY("NOTIFY")
////    func NOTIFY() -> String { "NOTIFY" }
////    
////    @SEARCH("SEARCH")
////    func SEARCH() -> String { "SEARCH" }
////    
////    @UNLOCK("UNLOCK")
////    func UNLOCK() -> String { "UNLOCK" }
////    
////    @REBIND("REBIND")
////    func REBIND() -> String { "REBIND" }
////    
////    @UNBIND("UNBIND")
////    func UNBIND() -> String { "UNBIND" }
////    
////    @REPORT("REPORT")
////    func REPORT() -> String { "REPORT" }
////    
////    @DELETE("DELETE")
////    func DELETE() -> String { "DELETE" }
////    
////    @UNLINK("UNLINK")
////    func UNLINK() -> String { "UNLINK" }
////    
////    @CONNECT("CONNECT")
////    func CONNECT() -> String { "CONNECT" }
////    
////    @MSEARCH("MSEARCH")
////    func MSEARCH() -> String { "MSEARCH" }
////    
////    @OPTIONS("OPTIONS")
////    func OPTIONS() -> String { "OPTIONS" }
////    
////    @PROPFIND("PROPFIND")
////    func PROPFIND() -> String { "PROPFIND" }
////    
////    @CHECKOUT("CHECKOUT")
////    func CHECKOUT() -> String { "CHECKOUT" }
////    
////    @PROPPATCH("PROPPATCH")
////    func PROPPATCH() -> String { "PROPPATCH" }
////    
////    @SUBSCRIBE("SUBSCRIBE")
////    func SUBSCRIBE() -> String { "SUBSCRIBE" }
////    
////    @MKCALENDAR("MKCALENDAR")
////    func MKCALENDAR() -> String { "MKCALENDAR" }
////    
////    @MKACTIVITY("MKACTIVITY")
////    func MKACTIVITY() -> String { "MKACTIVITY" }
////    
////    @UNSUBSCRIBE("UNSUBSCRIBE")
////    func UNSUBSCRIBE() -> String { "UNSUBSCRIBE" }
//
//    @SOURCE("SOURCE")
//    func SOURCE() -> String { "SOURCE" }
////    @Route(.RAW(value: "RAW"))
////    func RAW() -> String { "RAW" }
//}
//
////@RouteCollection
////struct Greetings {
////    @Route(.GET, "greet")
////    func greet() -> String {
////        "Hello"
////    }
////
////    @Route(.GET, "greet")
////    func greet(@Query name: String) -> String {
////        "Hello \(name)"
////    }
////}
//
//struct VaporTest: TestTrait, SuiteTrait {
//}
//
//struct VaporTestApplication {}
//
//@Test
//func noParameters() async throws {
//    let app = try await Application.make()
//    try app.register(collection: MethodTestingRoutes())
//    
//    print(app.routes)
//    let res = try await app.sendRequest(.GET, "GET")
//    #expect(res.status == .ok)
//    #expect(try res.content.decode(String.self, as: .plainText) == "GET")
//    try await app.asyncShutdown()
//}
