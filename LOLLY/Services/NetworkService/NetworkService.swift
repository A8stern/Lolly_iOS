import Foundation

public enum NetworkClientError: Error {
    case invalidURL
    case httpError(statusCode: Int, data: Data?)
    case encodingError(Error)
    case decodingError(Error)
    case transportError(Error)
    case missingData
    case emptyBodyExpectedNonEmptyResponse
}

public actor NetworkService {
    public let baseURL: URL? = URL(string: "https://lolly-project.ru")
    private let session: URLSession

    public init(session: URLSession) {
        self.session = session
    }

    // MARK: - private request

    // MARK: Post Put Patch

    public func request<Response: ResponseModel>(
        endpoint: String,
        method: HTTPMethod,
        body: some RequestModel,
        headers: [String: String] = [:]
    ) async throws -> Response {
        guard let url = URL(string: endpoint, relativeTo: baseURL) else {
            throw NetworkClientError.invalidURL
        }
        var request = createRequest(url: url, method: method, headers: headers)

        do {
            let encodedBody = try await Task(priority: .background) {
                try JSONEncoder().encode(body)
            }.value
            if let jsonString = String(data: encodedBody, encoding: .utf8) {
                print("REQUEST BODY JSON:", jsonString)
            }
            request.httpBody = encodedBody
        } catch {
            throw NetworkClientError.encodingError(error)
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkClientError.transportError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkClientError.missingData
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkClientError.httpError(statusCode: httpResponse.statusCode, data: data)
        }

        return try await decode(Response.self, from: data)
    }

    // MARK: Get Delete

    public func request<Response: ResponseModel>(
        endpoint: String,
        method: HTTPMethod = .get,
        headers: [String: String] = [:]
    ) async throws -> Response {
        guard let url = buildURL(endpoint: endpoint) else {
            throw NetworkClientError.invalidURL
        }

        let request = createRequest(
            url: url,
            method: method,
            headers: headers
        )
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkClientError.transportError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkClientError.missingData
        }
        guard 200..<300 ~= httpResponse.statusCode else {
            throw NetworkClientError.httpError(statusCode: httpResponse.statusCode, data: data)
        }
        if data.isEmpty, httpResponse.statusCode == 204 {
            throw NetworkClientError.emptyBodyExpectedNonEmptyResponse
        }

        return try await decode(Response.self, from: data)
    }

    // MARK: - private

    private func buildURL(endpoint: String) -> URL? {
        let cleanEndpoint = endpoint.hasPrefix("/") ? String(endpoint.dropFirst()) : endpoint
        return URL(string: cleanEndpoint, relativeTo: baseURL)
    }

    private func createRequest(
        url: URL,
        method: HTTPMethod,
        headers: [String: String]
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }

    private func decode<Response: ResponseModel & Sendable>(
        _: Response.Type,
        from data: Data
    ) async throws -> Response {
        if data.isEmpty {
            /// Если вызывающий ожидает пустой ответ — считаем это нормой
            if let empty = EmptyResponseModel() as? Response {
                return empty
            } else {
                throw NetworkClientError.emptyBodyExpectedNonEmptyResponse
            }
        }

        /// Непустое тело
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                let formatter1 = ISO8601DateFormatter()
                formatter1.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                let formatter2 = ISO8601DateFormatter()
                formatter2.formatOptions = [.withInternetDateTime]
                if let date = formatter1.date(from: dateString) {
                    return date
                }
                if let date = formatter2.date(from: dateString) {
                    return date
                }
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Cannot decode date string: \(dateString)"
                )
            }

            return try await Task(priority: .background) {
                try decoder.decode(Response.self, from: data)
            }.value
        } catch {
            throw NetworkClientError.decodingError(error)
        }
    }
}
