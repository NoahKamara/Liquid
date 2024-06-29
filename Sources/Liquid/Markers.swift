
/// A marker that tells ``Liquid`` to decode this value from the body
@propertyWrapper
public struct Body<Value: Decodable> {
    public let wrappedValue: Value

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}

/// A marker that tells ``Liquid`` to decode this value from the request's path
@propertyWrapper
public struct Path<Value: Decodable> {
    public let wrappedValue: Value

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public init(wrappedValue: Value, _ name: String) {
        self.init(wrappedValue: wrappedValue)
    }
}

/// A marker that tells ``Liquid`` to decode this value from the request's header
@propertyWrapper
public struct Header<Value: Decodable> {
    public let wrappedValue: Value

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public init(wrappedValue: Value, _ name: String) {
        self.init(wrappedValue: wrappedValue)
    }
}

/// A marker that tells ``Liquid`` to decode this value from the request's query
@propertyWrapper
public struct Query<Value: Decodable> {
    public let wrappedValue: Value

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public init(wrappedValue: Value, _ name: String) {
        self.init(wrappedValue: wrappedValue)
    }
}

extension Query {
    public init<Wrapped>(
        wrappedValue: Value,
        _ name: String,
        required: Bool
    ) where Value == Optional<Wrapped>{
        self.init(wrappedValue: wrappedValue)
    }
}
