
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
