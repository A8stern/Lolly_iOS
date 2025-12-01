//
//  NetworkClientError.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 29.11.2025.
//

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

extension NetworkClientError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .invalidURL:
                return "Неверный URL."

            case .httpError(_, let data):
                return extractMessage(from: data) ?? "Что-то пошло не так. Попробуйте позже."

            case .encodingError(let error):
                return "Что-то пошло не так. Не смогли сериализовать данные: \(error.localizedDescription)"

            case .decodingError(let error):
                return "Что-то пошло не так. Не смогли расшифровать данные: \(error.localizedDescription)"

            case .transportError(let error):
                return error.localizedDescription

            case .missingData:
                return "Что-то пошло не так. Кажется мы что-то потеряли..."

            case .emptyBodyExpectedNonEmptyResponse:
                return "Что-то пошло не так. Кажется ответ до нас не дошёл..."
        }
    }

    // MARK: - Private helper

    private func extractMessage(from data: Data?) -> String? {
        guard let data = data else { return nil }

        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
            let json = jsonObject as? [String: Any] {
            // Попытка извлечь разные варианты ключа
            if let message = json["message"] as? String {
                return message
            } else if let errorMessage = json["error"] as? String {
                return errorMessage
            }
        }
        return nil
    }
}

extension Error {
    var readableDescription: String {
        if let localized = self as? LocalizedError {
            return localized.errorDescription ?? self.localizedDescription
        } else {
            return self.localizedDescription
        }
    }
}
