import Foundation

final class NetworkServiceImpl: NetworkService {
    
    private let session: URLSession
    private let cachePolicy: URLRequest.CachePolicy
    
    init(
        session: URLSession = .shared,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    ) {
        self.session = session
        self.cachePolicy = cachePolicy
    }
    
    func request(_ type: RequestType) async throws -> Data {
        guard let url = type.url else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(
            url: url,
            cachePolicy: cachePolicy
        )
        request.httpMethod = type.method.rawValue
        
        for (field, value) in type.headers {
            request.setValue(value, forHTTPHeaderField: field)
        }
        
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(for: request)
        } catch let error as URLError where error.code == .cancelled {
            throw NetworkError.cancelled
        } catch let error as URLError where error.code == .notConnectedToInternet {
            throw NetworkError.noConnection
        }
        
        try validate(response)
        
        return data
    }
    
    func decode<T: Decodable>(from data: Data) throws -> T {
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding
        }
    }
    
    func validate(_ response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.badResponse
        }
        
        switch response.statusCode {
        case 200..<300:
            return
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 402:
            throw NetworkError.quotaExceeded
        case 429:
            throw NetworkError.rateLimited
        default:
            throw NetworkError.badResponse
        }
    }
}
