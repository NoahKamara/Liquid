import Vapor


@attached(peer)
public macro CollectableRoute(_ method: HTTPMethod) = #externalMacro(module: "LiquidMacros", type: "DecoratorMacro")


// MARK: Collection

/// Use this method as a GET request
/// - Parameter method: HTTP Method for this request
/// - Parameter path: the subpath to the endpoint
@attached(extension, conformances: Vapor.RouteCollection, names: named(boot))
@attached(member)
public macro RouteCollection(
    prefixed path: PathComponent...
) = #externalMacro(module: "LiquidMacros", type: "RouteCollectionMacro")

// MARK: Route

/// Use this method as a GET request
/// - Parameter method: HTTP Method for this request
/// - Parameter path: the subpath to the endpoint
@attached(peer, names: overloaded)
public macro Route(
    _ method: HTTPMethod,
    _ path: PathComponent...
) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

// MARK: Methods

/// Use this method as a GET request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro GET(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a PUT request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro PUT(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a ACL request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro ACL(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a HEAD request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro HEAD(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a POST request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro POST(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a COPY request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro COPY(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a LOCK request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro LOCK(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a MOVE request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro MOVE(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a BIND request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro BIND(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a LINK request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro LINK(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a PATCH request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro PATCH(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a TRACE request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro TRACE(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a MKCOL request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro MKCOL(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a MERGE request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro MERGE(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a PURGE request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro PURGE(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a NOTIFY request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro NOTIFY(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a SEARCH request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro SEARCH(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a UNLOCK request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro UNLOCK(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a REBIND request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro REBIND(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a UNBIND request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro UNBIND(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a REPORT request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro REPORT(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a DELETE request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro DELETE(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a UNLINK request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro UNLINK(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a CONNECT request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro CONNECT(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a MSEARCH request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro MSEARCH(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a OPTIONS request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro OPTIONS(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a PROPFIND request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro PROPFIND(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a CHECKOUT request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro CHECKOUT(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a PROPPATCH request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro PROPPATCH(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a SUBSCRIBE request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro SUBSCRIBE(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a MKCALENDAR request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro MKCALENDAR(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a MKACTIVITY request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro MKACTIVITY(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a UNSUBSCRIBE request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro UNSUBSCRIBE(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")

/// Use this method as a SOURCE request
/// - Parameter path: the subpath to the endpoint relative to
@attached(peer, names: overloaded)
public macro SOURCE(_ path: PathComponent...) = #externalMacro(module: "LiquidMacros", type: "RouteMacro")


