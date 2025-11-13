//
//  Endpoint.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 14.11.2025.
//


import Foundation

// MARK: - Common Protocol

public protocol Endpoint {
    /// Путь относительно baseURL
    var path: String { get }

    /// HTTP-метод
    var method: HTTPMethod { get }

    /// Заголовки (без общих)
    var headers: [String: String] { get }

    /// Полный endpoint
    var endpoint: String { get }
}

public extension Endpoint {
    var endpoint: String { path }
}
