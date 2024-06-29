//import Vapor
//import Testing
//import NIOConcurrencyHelpers
//
///**
// We recommend configuring this in your test’s `class func setUp()`
// */
//public var app: (@Sendable () throws -> Application)! {
//    get {
//        appBox.withLockedValue({ $0 })
//    }
//    set {
//        appBox.withLockedValue { $0 = newValue }
//    }
//}
//private let appBox: NIOLockedValueBox<(@Sendable () throws -> Application)?> = .init(nil)
//
