import Foundation

final class NetworkServiceImpl: NetworkService {
    
    private let path: String
    private let cachePolicy: URLRequest.CachePolicy
    
    init(
        path: String,
        cachePolicy: URLRequest.CachePolicy = .returnCacheDataDontLoad
    ) {
        self.path = path
        self.cachePolicy = cachePolicy
    }
    
    func request() async throws -> Data {
        guard let url = URL(string: path) else {
            throw NetworkError.badURL
        }
        
        let request = URLRequest(
            url: url,
            cachePolicy: cachePolicy
        )
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard isValid(with: response) else {
            throw NetworkError.badResponse
        }
        
        return data
    }
    
    func decode<T: Codable>(from data: Data) throws -> T {
        let decoder = JSONDecoder()
        
        return try decoder.decode(T.self, from: data)
    }
    
    func isValid(with response: URLResponse) -> Bool {
        guard let response = response as? HTTPURLResponse else { return false }
        
        return response.statusCode ~= 200
    }
    
}
