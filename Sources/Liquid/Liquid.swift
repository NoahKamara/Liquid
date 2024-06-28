// The Swift Programming Language
// https://docs.swift.org/swift-book

import Vapor

// MARK: Route

/// Use this method as a GET request
/// - Parameter method: HTTP Method for this request
/// - Parameter path: the subpath to the endpoint
@attached(peer, names: overloaded)
public macro Route(
    _ method: HTTPMethod,
    _ path: PathComponent...
) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")
