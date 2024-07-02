
// MARK: Path
extension RouteParameters {
    public struct Path<Value>: RouteParameter {
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
}

// MARK: Default Conformances

public extension RawRepresentable where Self: LosslessStringConvertible, RawValue == String {
    var description: String { rawValue }

    init?(_ description: String) {
        self.init(rawValue: description)
    }
}
