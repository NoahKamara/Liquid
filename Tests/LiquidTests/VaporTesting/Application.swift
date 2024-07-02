extension Application {
    public func get(
        _ path: String...,
        parameters: (String, LosslessStringConvertible)...,
        headers: HTTPHeaders = [:],
        body: ByteBuffer? = nil,
        beforeSend: @escaping (XCTHTTPRequest) throws -> Void = {  _ in }
    ) async throws -> XCTHTTPResponse {
        try await send(.GET, path, parameters: parameters, headers: headers, body: body, beforeSend: beforeSend)
    }

    public func get(
        _ path: String...,
        parameters: [(String, LosslessStringConvertible)] = [],
        headers: HTTPHeaders = [:],
        body: ByteBuffer? = nil,
        beforeSend: @escaping (XCTHTTPRequest) throws -> Void = {  _ in }
    ) async throws -> XCTHTTPResponse {
        try await send(.GET, path, parameters: parameters, headers: headers, body: body, beforeSend: beforeSend)
    }

    public func send(
        _ method: HTTPMethod,
        _ path: String...,
        parameters: [(String, LosslessStringConvertible)] = [],
        headers: HTTPHeaders = [:],
        body: ByteBuffer? = nil,
        beforeSend: @escaping (XCTHTTPRequest) throws -> Void = {  _ in }
    ) async throws -> XCTHTTPResponse {
        try await send(method, path, parameters: parameters, headers: headers, body: body, beforeSend: beforeSend)
    }

    public func send(
        _ method: HTTPMethod,
        _ path: String...,
        parameters: (String, LosslessStringConvertible)...,
        headers: HTTPHeaders = [:],
        body: ByteBuffer? = nil,
        beforeSend: @escaping (XCTHTTPRequest) throws -> Void = {  _ in }
    ) async throws -> XCTHTTPResponse {
        try await send(method, path, parameters: parameters, headers: headers, body: body, beforeSend: beforeSend)
    }

    public func send(
        _ method: HTTPMethod,
        _ path: [String],
        parameters: [(String, LosslessStringConvertible)] = [],
        headers: HTTPHeaders = [:],
        body: ByteBuffer? = nil,
        beforeSend: (XCTHTTPRequest) throws -> Void = {  _ in }
    ) async throws -> XCTHTTPResponse {
        let request = XCTHTTPRequest(
            method: method,
            url: .init(path: path.joined(separator: "/"), query: parameters.map({ $0+"="+$1.description }).joined(separator: "&")),
            headers: headers,
            body: body ?? ByteBufferAllocator().buffer(capacity: 0)
        )
        try beforeSend(request)
        return try await self.performTest(request: request)
    }

    public func send(
        _ method: HTTPMethod,
        _ path: [String],
        headers: HTTPHeaders = [:],
        body: ByteBuffer? = nil,
        beforeSend: (XCTHTTPRequest) throws -> Void = {  _ in }
    ) async throws -> XCTHTTPResponse {
        let request = XCTHTTPRequest(
            method: method,
            url: .init(path: path.joined(separator: "/")),
            headers: headers,
            body: body ?? ByteBufferAllocator().buffer(capacity: 0)
        )
        try beforeSend(request)
        return try await self.performTest(request: request)
    }
}
