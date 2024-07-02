
// MARK: Query
extension RouteParameters {
    public struct Query<Value: Decodable>: RouteParameter {
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
            do {
                return try request.query.get(Value.self, at: path)
            } catch let error as DecodingError {
                throw ValidationError(decodingError: error, at: path, in: .query)
            }
        }
    }
}

public enum ValidationDomain: String, Codable {
    case query = "query"
}

public struct ValidationError: Content, Error {
    public var status: NIOHTTP1.HTTPResponseStatus { .badRequest }

    internal init(path: [CodingKeyRepresentable], message: String, domain: ValidationDomain) {
        self.path = path.map(\.codingKey).dotPath
        self.message = message
        self.domain = domain
    }
    
    let path: String
    let domain: ValidationDomain
    let message: String

    init(decodingError: DecodingError, at path: [CodingKeyRepresentable], in domain: ValidationDomain) {
        switch decodingError {
            case .typeMismatch(_, let context):
                self.init(path: path, message: context.debugDescription, domain: domain)
            case .valueNotFound( _, let context):
                self.init(path: path, message: context.debugDescription, domain: domain)
            case .keyNotFound(_, let context):
                self.init(path: path, message: context.debugDescription, domain: domain)
            case .dataCorrupted(let context):
                self.init(path: path, message: context.debugDescription, domain: domain)
            @unknown default:
                self.init(path: path, message: "Unknown error: \(decodingError.description)", domain: domain)
        }
    }

    /// The reason for this error.
    var reason: String {
        ""
    }

//
//    /// Optional `HTTPHeaders` to add to the error response.
//    var headers: HTTPHeaders { get }
}

