
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
public struct Path<Value> {
    public let wrappedValue: Value
    
    
    /// Decode this parameter from a named parameter (`:name`)
    ///
    /// you can specify a custo name, otherwise it is inferred from the parameter name
    public init(wrappedValue: Value, _ name: String = "") where Value: LosslessStringConvertible {
        self.wrappedValue = wrappedValue
    }

    public enum Catchall {
        case catchall
    }

    /// Retrieve the path components caught by a 'catch all' (`**`)
    ///
    /// Parameter _: a catchall statement. must be ``Catchall.catchall``
    public init(wrappedValue: Value, _: Catchall) where Value == [String] {
        self.wrappedValue = wrappedValue
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
