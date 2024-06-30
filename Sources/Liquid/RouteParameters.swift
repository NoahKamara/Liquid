import Foundation
import Vapor

public struct RouteParameters {}

public protocol RouteParameter<Value>: ~Copyable {
    associatedtype Value

    func decode(from request: Request) throws -> Value
}

public extension RouteParameter {
    func callAsFunction(from request: Request) throws -> Value {
        try self.decode(from: request)
    }
}

// MARK: Default
public extension RouteParameters {
    struct Default<P: RouteParameter>: RouteParameter {
        let parameter: P
        let defaultValue: P.Value

        init(parameter: P, defaultValue: P.Value) {
            self.parameter = parameter
            self.defaultValue = defaultValue
        }

        public func decode(from request: Request) throws -> P.Value {
            do {
                return try parameter(from: request)
            } catch DecodingError.valueNotFound {
                return defaultValue
            }
        }
    }
}

extension RouteParameter {
    consuming func defaults(to value: Value) -> some RouteParameter<Value> {
        return RouteParameters.Default(parameter: self, defaultValue: value)
    }
}

// MARK: Body
public extension RouteParameters {
    struct Body<Value: Decodable>: RouteParameter {
        let path: [CodingKeyRepresentable]

        internal init(path: [any CodingKeyRepresentable]) {
            self.path = path
        }

        init(
            _: Value.Type,
            at path: CodingKeyRepresentable...
        ) {
            self.init(path: path)
        }

        init(
            _: Value.Type
        ) {
            self.init(path: [])
        }

        public func decode(from request: Request) throws -> Value {
            try request.content.get(Value.self, at: path)
        }
    }
}

// MARK: Query
public extension RouteParameters {
    struct Query<Value: Decodable>: RouteParameter {
        let path: [CodingKeyRepresentable]

        internal init(path: [any CodingKeyRepresentable]) {
            self.path = path
        }

        public init(
            _: Value.Type,
            _ path: CodingKeyRepresentable...
        ) {
            self.init(path: path)
        }

        public func decode(from request: Request) throws -> Value {
            try request.query.get(Value.self, at: path)
        }
    }
}

// MARK: Path
public extension RouteParameters {
    fileprivate struct PathParameter<Value: LosslessStringConvertible>: RouteParameter {
        let name: String
        func decode(from request: Request) throws -> Value {
            try request.parameters.require(name, as: Value.self)
        }
    }

    fileprivate struct PathCatchall: RouteParameter {
        func decode(from request: Request) -> [String] {
            request.parameters.getCatchall()
        }
    }

    struct Path<Value>: RouteParameter {
        public enum Parameter: ExpressibleByStringInterpolation, Sendable, Hashable {
            case parameter(String)
            case catchall

            /// `ExpressibleByStringLiteral` conformance.
            public init(stringLiteral value: String) {
                if value == "**" {
                    self = .catchall
                } else {
                    self = .parameter(.init(value))
                }
            }
        }
        
        let decoder: any RouteParameter<Value>

        init(_ decoder: some RouteParameter<Value>) {
            self.decoder = decoder
        }

        public init(
            _: Value.Type,
            _ name: String
        ) where Value: LosslessStringConvertible {
            self.init(PathParameter(name: name))
        }

        public init(
            _: Value.Type,
            _ parameter: Liquid.Path<Value>.Catchall
        ) where Value == [String] {
            self.init(PathCatchall())
        }

        public func decode(from request: Request) throws -> Value {
            try decoder(from: request)
        }
    }
}
