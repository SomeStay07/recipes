import Foundation

enum NetworkError: Error, Equatable {
    case badURL
    case badRequest
    case badResponse
    case unauthorized
    case forbidden
    case quotaExceeded
    case rateLimited
    case decoding
    case noConnection
    case cancelled
    case localized(description: String)
}
