import Foundation

struct RequestType {
    
    enum Method: String {
        case get = "GET"
    }
    
    let host: String
    let path: String
    let method: Method
    let queryItems: [URLQueryItem]
    let headers: [String: String]
    
    init(
        host: String,
        path: String,
        method: Method = .get,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:]
    ) {
        self.host = host
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        
        return components.url
    }
}
