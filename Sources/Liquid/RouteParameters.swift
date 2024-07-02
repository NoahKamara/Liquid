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
    struct Default<Wrapped, P: RouteParameter<Wrapped?>>: RouteParameter {
        let parameter: P
        let defaultValue: Wrapped

        init(parameter: P, defaultValue: Wrapped) {
            self.parameter = parameter
            self.defaultValue = defaultValue
        }

        public func decode(from request: Request) throws -> Wrapped {
            do {
                return try parameter(from: request) ?? defaultValue
            } catch DecodingError.valueNotFound {
                return defaultValue
            }
        }
    }
}

public extension RouteParameter {
    consuming func defaults<Wrapped>(
        to value: Wrapped
    ) -> some RouteParameter<Wrapped> where Value == Optional<Wrapped> {
        return RouteParameters.Default(parameter: self, defaultValue: value)
    }
}
