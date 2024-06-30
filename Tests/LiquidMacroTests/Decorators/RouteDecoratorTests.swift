import XCTest
import MacroTesting
import SwiftSyntaxMacros
@testable import LiquidMacros

final class RouteDecoratorTests: XCTestCase {
    let source = { (method: String) in
        """
        @RouteCollection
        struct Greetings {
            @Route(.\(method), "greet")
            func greet() -> String {
                "Hello World"
            }
        }
        """
    }

    let expansion = { (method: String) in
        """
        struct Greetings {
            @Route(.\(method), "greet")
            @CollectableRoute(.\(method), "greet")
            func greet() -> String {
                "Hello World"
            }
        }

        extension Greetings: RouteCollection {
            func boot(routes: any RoutesBuilder) throws {
                routes.on(.\(method), "greet") {
                    self.greet(request: $0)
                }
            }
        }
        """
    }

    override func invokeTest() {
        withMacroTesting(
            macros: ["RouteCollection": RouteCollectionMacro.self]
        ) {
            super.invokeTest()
        }
    }

    func testGET() throws {
        // self.expansion
        assertMacro {
            source("GET")
        } expansion: { [self] in
            self.expansion("GET")
        }
    }

    func testPUT() throws {
        assertMacro {
            source("PUT")
        } expansion: { [self] in
            self.expansion("PUT")
        }
    }

    func testACL() throws {
        assertMacro {
            source("ACL")
        } expansion: { [self] in
            self.expansion("ACL")
        }
    }

    func testHEAD() throws {
        assertMacro {
            source("HEAD")
        } expansion: { [self] in
            self.expansion("HEAD")
        }
    }

    func testPOST() throws {
        assertMacro {
            source("POST")
        } expansion: { [self] in
            self.expansion("POST")
        }
    }

    func testCOPY() throws {
        assertMacro {
            source("COPY")
        } expansion: { [self] in
            self.expansion("COPY")
        }
    }

    func testLOCK() throws {
        assertMacro {
            source("LOCK")
        } expansion: { [self] in
            self.expansion("LOCK")
        }
    }

    func testMOVE() throws {
        assertMacro {
            source("MOVE")
        } expansion: { [self] in
            self.expansion("MOVE")
        }
    }

    func testBIND() throws {
        assertMacro {
            source("BIND")
        } expansion: { [self] in
            self.expansion("BIND")
        }
    }

    func testLINK() throws {
        assertMacro {
            source("LINK")
        } expansion: { [self] in
            self.expansion("LINK")
        }
    }

    func testPATCH() throws {
        assertMacro {
            source("PATCH")
        } expansion: { [self] in
            self.expansion("PATCH")
        }
    }

    func testTRACE() throws {
        assertMacro {
            source("TRACE")
        } expansion: { [self] in
            self.expansion("TRACE")
        }
    }

    func testMKCOL() throws {
        assertMacro {
            source("MKCOL")
        } expansion: { [self] in
            self.expansion("MKCOL")
        }
    }

    func testMERGE() throws {
        assertMacro {
            source("MERGE")
        } expansion: { [self] in
            self.expansion("MERGE")
        }
    }

    func testPURGE() throws {
        assertMacro {
            source("PURGE")
        } expansion: { [self] in
            self.expansion("PURGE")
        }
    }

    func testNOTIFY() throws {
        assertMacro {
            source("NOTIFY")
        } expansion: { [self] in
            self.expansion("NOTIFY")
        }
    }

    func testSEARCH() throws {
        assertMacro {
            source("SEARCH")
        } expansion: { [self] in
            self.expansion("SEARCH")
        }
    }

    func testUNLOCK() throws {
        assertMacro {
            source("UNLOCK")
        } expansion: { [self] in
            self.expansion("UNLOCK")
        }
    }

    func testREBIND() throws {
        assertMacro {
            source("REBIND")
        } expansion: { [self] in
            self.expansion("REBIND")
        }
    }

    func testUNBIND() throws {
        assertMacro {
            source("UNBIND")
        } expansion: { [self] in
            self.expansion("UNBIND")
        }
    }

    func testREPORT() throws {
        assertMacro {
            source("REPORT")
        } expansion: { [self] in
            self.expansion("REPORT")
        }
    }

    func testDELETE() throws {
        assertMacro {
            source("DELETE")
        } expansion: { [self] in
            self.expansion("DELETE")
        }
    }

    func testUNLINK() throws {
        assertMacro {
            source("UNLINK")
        } expansion: { [self] in
            self.expansion("UNLINK")
        }
    }

    func testCONNECT() throws {
        assertMacro {
            source("CONNECT")
        } expansion: { [self] in
            self.expansion("CONNECT")
        }
    }

    func testMSEARCH() throws {
        assertMacro {
            source("MSEARCH")
        } expansion: { [self] in
            self.expansion("MSEARCH")
        }
    }

    func testOPTIONS() throws {
        assertMacro {
            source("OPTIONS")
        } expansion: { [self] in
            self.expansion("OPTIONS")
        }
    }

    func testPROPFIND() throws {
        assertMacro {
            source("PROPFIND")
        } expansion: { [self] in
            self.expansion("PROPFIND")
        }
    }

    func testCHECKOUT() throws {
        assertMacro {
            source("CHECKOUT")
        } expansion: { [self] in
            self.expansion("CHECKOUT")
        }
    }

    func testPROPPATCH() throws {
        assertMacro {
            source("PROPPATCH")
        } expansion: { [self] in
            self.expansion("PROPPATCH")
        }
    }

    func testSUBSCRIBE() throws {
        assertMacro {
            source("SUBSCRIBE")
        } expansion: { [self] in
            self.expansion("SUBSCRIBE")
        }
    }

    func testMKCALENDAR() throws {
        assertMacro {
            source("MKCALENDAR")
        } expansion: { [self] in
            self.expansion("MKCALENDAR")
        }
    }

    func testMKACTIVITY() throws {
        assertMacro {
            source("MKACTIVITY")
        } expansion: { [self] in
            self.expansion("MKACTIVITY")
        }
    }

    func testUNSUBSCRIBE() throws {
        assertMacro {
            source("UNSUBSCRIBE")
        } expansion: { [self] in
            self.expansion("UNSUBSCRIBE")
        }
    }

    func testSOURCE() throws {
        assertMacro {
            source("SOURCE")
        } expansion: { [self] in
            self.expansion("SOURCE")
        }
    }
}
