import XCTest
import MacroTesting
@testable import LiquidMacros


final class RouteMacroTests: XCTestCase {
    let expansion = """
    func greet() -> String {
        "Hello World"
    }

    func greet(request: Request) -> String {
        return greet()
    }
    """

    override func invokeTest() {
        withMacroTesting(
            macros: [
                "Route": RouteMacro.self,

            ]
        ) {
            super.invokeTest()
        }
    }

    func testEnumCase() throws {
        assertMacro {
            """
            @Route(.GET, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }

    func testGET() throws {
        assertMacro {
            """
            @Route(.GET, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testPUT() throws {
        assertMacro {
            """
            @Route(.PUT, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testACL() throws {
        assertMacro {
            """
            @Route(.ACL, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testHEAD() throws {
        assertMacro {
            """
            @Route(.HEAD, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testPOST() throws {
        assertMacro {
            """
            @Route(.POST, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testCOPY() throws {
        assertMacro {
            """
            @Route(.COPY, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testLOCK() throws {
        assertMacro {
            """
            @Route(.LOCK, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testMOVE() throws {
        assertMacro {
            """
            @Route(.MOVE, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testBIND() throws {
        assertMacro {
            """
            @Route(.BIND, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testLINK() throws {
        assertMacro {
            """
            @Route(.LINK, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testPATCH() throws {
        assertMacro {
            """
            @Route(.PATCH, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testTRACE() throws {
        assertMacro {
            """
            @Route(.TRACE, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testMKCOL() throws {
        assertMacro {
            """
            @Route(.MKCOL, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testMERGE() throws {
        assertMacro {
            """
            @Route(.MERGE, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testPURGE() throws {
        assertMacro {
            """
            @Route(.PURGE, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testNOTIFY() throws {
        assertMacro {
            """
            @Route(.NOTIFY, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testSEARCH() throws {
        assertMacro {
            """
            @Route(.SEARCH, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testUNLOCK() throws {
        assertMacro {
            """
            @Route(.UNLOCK, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testREBIND() throws {
        assertMacro {
            """
            @Route(.REBIND, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testUNBIND() throws {
        assertMacro {
            """
            @Route(.UNBIND, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testREPORT() throws {
        assertMacro {
            """
            @Route(.REPORT, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testDELETE() throws {
        assertMacro {
            """
            @Route(.DELETE, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testUNLINK() throws {
        assertMacro {
            """
            @Route(.UNLINK, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testCONNECT() throws {
        assertMacro {
            """
            @Route(.CONNECT, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testMSEARCH() throws {
        assertMacro {
            """
            @Route(.MSEARCH, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testOPTIONS() throws {
        assertMacro {
            """
            @Route(.OPTIONS, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testPROPFIND() throws {
        assertMacro {
            """
            @Route(.PROPFIND, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testCHECKOUT() throws {
        assertMacro {
            """
            @Route(.CHECKOUT, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testPROPPATCH() throws {
        assertMacro {
            """
            @Route(.PROPPATCH, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testSUBSCRIBE() throws {
        assertMacro {
            """
            @Route(.SUBSCRIBE, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testMKCALENDAR() throws {
        assertMacro {
            """
            @Route(.MKCALENDAR, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testMKACTIVITY() throws {
        assertMacro {
            """
            @Route(.MKACTIVITY, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testUNSUBSCRIBE() throws {
        assertMacro {
            """
            @Route(.UNSUBSCRIBE, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testSOURCE() throws {
        assertMacro {
            """
            @Route(.SOURCE, "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
    func testRAW() throws {
        assertMacro {
            """
            @Route("RAWSTRING", "greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
}
