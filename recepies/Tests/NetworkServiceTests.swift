import Foundation
import Testing
@testable import recepies

struct NetworkTests {
    
    @Test func urlEncodesAmpersandInsideValue() throws {
        let request = RequestType(
            host: "example.com",
            path: "/recipes/complexSearch",
            queryItems: [URLQueryItem(name: "query", value: "salt & pepper")]
        )
        
        let url = try #require(request.url)
        
        #expect(url.absoluteString == "https://example.com/recipes/complexSearch?query=salt%20%26%20pepper")
    }
    
    @Test(arguments: [
        (401, NetworkError.unauthorized),
        (403, NetworkError.forbidden),
        (402, NetworkError.quotaExceeded),
        (429, NetworkError.rateLimited),
        (500, NetworkError.badResponse)
    ])
    func statusCodeBecomesError(code: Int, expected: NetworkError) {
        #expect(throws: expected) {
            try NetworkServiceImpl().validate(response(code: code))
        }
    }
    
    @Test func decodeParsesSearchResponse() throws {
        let json = """
        {
          "results": [
            { "id": 716429, "title": "Pasta with Garlic", "image": null, "imageType": "jpg" }
          ],
          "totalResults": 42
        }
        """
        
        let response: RecipeSearchResponse = try NetworkServiceImpl().decode(from: Data(json.utf8))
        
        #expect(response.totalResults == 42)
        #expect(response.results.map(\.id) == [716429])
    }
    
    @Test func placeholderKeyIsIgnored() {
        let bundle = InfoDictionaryStub(value: "PUT_YOUR_SPOONACULAR_KEY_HERE")
        
        #expect(ApiKeyProvider.key(for: "SpoonacularApiKey", bundle: bundle) == nil)
    }
}

// MARK: - Helpers

private func response(code: Int) -> HTTPURLResponse {
    HTTPURLResponse(
        url: URL(string: "https://example.com")!,
        statusCode: code,
        httpVersion: nil,
        headerFields: nil
    )!
}

private struct InfoDictionaryStub: InfoDictionaryProvider {
    
    let value: Any?
    
    func object(forInfoDictionaryKey key: String) -> Any? {
        value
    }
}
