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
            at path: CodingKeyRepresentable...
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
    struct Path<Value: LosslessStringConvertible>: RouteParameter {
        let name: PathComponent
        
        public init(
            _: Value.Type,
            _ name: PathComponent
        ) {
            self.name = name
        }

        public func decode(from request: Request) throws -> Value {
            switch name {
                case .constant, .anything:
                    throw DecodingError.dataCorrupted(.init(
                        codingPath: [],
                        debugDescription: "PathComponent must be parameter or catchall")
                    )

                case .parameter(let string):
                    try request.parameters.require(string, as: Value.self)

                case .catchall:
                    if Value.self == [String].self {
                        request.parameters.getCatchall() as! Value
                    } else {
                        throw DecodingError.dataCorrupted(.init(
                            codingPath: [],
                            debugDescription: "Value.self must be of [String]")
                        )
                    }
            }
        }
    }
}
