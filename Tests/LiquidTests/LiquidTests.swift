import XCTest
import MacroTesting
import LiquidMacros


class MacroTest: XCTestCase {
    override func invokeTest() {
        withMacroTesting(
            macros: [
                "Route": RouteMacro.self
            ]
        ) {
            super.invokeTest()
        }
    }
}

final class RouteMacroTests: XCTestCase {
    func testNoParams() throws {
        assertMacro {
            """
            @Route(.GET)
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            """
            func greet() -> String {
                "Hello World"
            }

            func greet(request: Request) -> String {
                return self.greet()
            }
            """
        }
    }
}
