import Foundation

enum SearchError: Equatable {
    case missingApiKey
    case accessDenied
    case noConnection
    case quotaExceeded
    case rateLimited
    case unknown
}

// MARK: - Mapping

extension SearchError {
    
    init(_ error: Error) {
        guard let error = error as? NetworkError else {
            self = .unknown
            return
        }
        
        switch error {
        case .unauthorized:
            self = .missingApiKey
        case .forbidden:
            self = .accessDenied
        case .noConnection:
            self = .noConnection
        case .quotaExceeded:
            self = .quotaExceeded
        case .rateLimited:
            self = .rateLimited
        case .badURL, .badRequest, .badResponse, .decoding, .cancelled, .localized:
            self = .unknown
        }
    }
}

// MARK: - Presentation

extension SearchError {
    
    var titleKey: String {
        switch self {
        case .missingApiKey:
            return "search.error.key.title"
        case .accessDenied:
            return "search.error.access.title"
        case .noConnection:
            return "search.error.connection.title"
        case .quotaExceeded:
            return "search.error.quota.title"
        case .rateLimited:
            return "search.error.rate.title"
        case .unknown:
            return "search.error.unknown.title"
        }
    }
    
    var subtitleKey: String {
        switch self {
        case .missingApiKey:
            return "search.error.key.subtitle"
        case .accessDenied:
            return "search.error.access.subtitle"
        case .noConnection:
            return "search.error.connection.subtitle"
        case .quotaExceeded:
            return "search.error.quota.subtitle"
        case .rateLimited:
            return "search.error.rate.subtitle"
        case .unknown:
            return "search.error.unknown.subtitle"
        }
    }
    
    var isRetryable: Bool {
        switch self {
        case .missingApiKey, .accessDenied, .quotaExceeded:
            return false
        case .noConnection, .rateLimited, .unknown:
            return true
        }
    }
}
