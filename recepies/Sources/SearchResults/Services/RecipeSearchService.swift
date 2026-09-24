import Foundation

// MARK: - RecipeSearchService

protocol RecipeSearchService {
    func search(query: String) async throws -> [Recipe]
}

// MARK: - SpoonacularSearchService

final class SpoonacularSearchService: RecipeSearchService {
    
    private enum Constants {
        static let host = "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        static let path = "/recipes/complexSearch"
        static let resultsPerPage = 20
    }
    
    private let network: NetworkService
    private let apiKey: String?
    
    init(
        network: NetworkService = NetworkServiceImpl(),
        apiKey: String? = ApiKeyProvider.spoonacular
    ) {
        self.network = network
        self.apiKey = apiKey
    }
    
    func search(query: String) async throws -> [Recipe] {
        guard let apiKey else {
            throw NetworkError.unauthorized
        }
        
        let data = try await network.request(makeRequest(query: query, apiKey: apiKey))
        let response: RecipeSearchResponse = try network.decode(from: data)
        
        return response.results
    }
}

// MARK: - Request

private extension SpoonacularSearchService {
    
    func makeRequest(query: String, apiKey: String) -> RequestType {
        RequestType(
            host: Constants.host,
            path: Constants.path,
            queryItems: [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "number", value: String(Constants.resultsPerPage))
            ],
            headers: [
                "X-RapidAPI-Key": apiKey,
                "X-RapidAPI-Host": Constants.host
            ]
        )
    }
}
