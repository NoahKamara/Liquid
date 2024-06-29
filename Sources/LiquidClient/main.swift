import Liquid

//@RouteCollection("greet")
struct Greetings {
    @Route(.GET, "world")
    func greetWorld() -> String {
        "Hello World"
    }
}
