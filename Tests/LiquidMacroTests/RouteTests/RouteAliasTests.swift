import XCTest
import MacroTesting
@testable import LiquidMacros


final class RouteAliasTests: XCTestCase {
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
            macros: .init(uniqueKeysWithValues: allowedRouteAliases.map({ ($0, RouteMacro.self) }))
        ) {
            super.invokeTest()
        }
    }

    func testGET() throws {
        assertMacro {
            """
            @GET("greet")
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
            @PUT("greet")
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
            @ACL("greet")
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
            @HEAD("greet")
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
            @POST("greet")
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
            @COPY("greet")
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
            @LOCK("greet")
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
            @MOVE("greet")
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
            @BIND("greet")
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
            @LINK("greet")
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
            @PATCH("greet")
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
            @TRACE("greet")
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
            @MKCOL("greet")
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
            @MERGE("greet")
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
            @PURGE("greet")
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
            @NOTIFY("greet")
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
            @SEARCH("greet")
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
            @UNLOCK("greet")
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
            @REBIND("greet")
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
            @UNBIND("greet")
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
            @REPORT("greet")
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
            @DELETE("greet")
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
            @UNLINK("greet")
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
            @CONNECT("greet")
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
            @MSEARCH("greet")
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
            @OPTIONS("greet")
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
            @PROPFIND("greet")
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
            @CHECKOUT("greet")
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
            @PROPPATCH("greet")
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
            @SUBSCRIBE("greet")
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
            @MKCALENDAR("greet")
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
            @MKACTIVITY("greet")
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
            @UNSUBSCRIBE("greet")
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
            @SOURCE("greet")
            func greet() -> String {
                "Hello World"
            }
            """
        } expansion: {
            self.expansion
        }
    }
}
