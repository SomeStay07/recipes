import Foundation
import XCTest
@testable import recepies

final class RequestTypeTests: XCTestCase {
    
    func test_url_buildsHttpsUrlWithQueryItems() throws {
        let request = RequestType(
            host: "example.com",
            path: "/recipes/complexSearch",
            queryItems: [
                URLQueryItem(name: "query", value: "pasta carbonara"),
                URLQueryItem(name: "number", value: "20")
            ]
        )
        
        let url = try XCTUnwrap(request.url)
        
        XCTAssertEqual(
            url.absoluteString,
            "https://example.com/recipes/complexSearch?query=pasta%20carbonara&number=20"
        )
    }
    
    func test_url_withoutQueryItems_hasNoQuestionMark() throws {
        let request = RequestType(host: "example.com", path: "/ping")
        let url = try XCTUnwrap(request.url)
        
        XCTAssertEqual(url.absoluteString, "https://example.com/ping")
    }
    
    func test_method_defaultsToGet() {
        let request = RequestType(host: "example.com", path: "/ping")
        
        XCTAssertEqual(request.method, .get)
    }
}

final class NetworkServiceImplTests: XCTestCase {
    
    private let service = NetworkServiceImpl()
    
    func test_validate_successStatus_doesNotThrow() throws {
        XCTAssertNoThrow(try service.validate(response(code: 200)))
        XCTAssertNoThrow(try service.validate(response(code: 204)))
    }
    
    func test_validate_unauthorizedStatus_throwsUnauthorized() {
        assertThrows(.unauthorized, for: 401)
    }
    
    func test_validate_forbiddenStatus_throwsForbidden() {
        assertThrows(.forbidden, for: 403)
    }
    
    func test_validate_paymentRequired_throwsQuotaExceeded() {
        assertThrows(.quotaExceeded, for: 402)
    }
    
    func test_validate_tooManyRequests_throwsRateLimited() {
        assertThrows(.rateLimited, for: 429)
    }
    
    func test_validate_serverError_throwsBadResponse() {
        assertThrows(.badResponse, for: 500)
    }
    
    func test_decode_brokenPayload_throwsDecoding() {
        let data = Data("{ not a json }".utf8)
        
        XCTAssertThrowsError(try service.decode(from: data) as RecipeSearchResponse) { error in
            XCTAssertEqual(error as? NetworkError, .decoding)
        }
    }
    
    func test_decode_searchResponse_parsesRecipes() throws {
        let json = """
        {
          "results": [
            {
              "id": 716429,
              "title": "Pasta with Garlic",
              "image": "https://img.spoonacular.com/recipes/716429-312x231.jpg",
              "imageType": "jpg"
            }
          ],
          "offset": 0,
          "number": 1,
          "totalResults": 42
        }
        """
        
        let response: RecipeSearchResponse = try service.decode(from: Data(json.utf8))
        
        XCTAssertEqual(response.totalResults, 42)
        XCTAssertEqual(response.results.count, 1)
        XCTAssertEqual(response.results.first?.id, 716429)
        XCTAssertEqual(response.results.first?.title, "Pasta with Garlic")
        XCTAssertEqual(
            response.results.first?.image?.absoluteString,
            "https://img.spoonacular.com/recipes/716429-312x231.jpg"
        )
    }
}

// MARK: - Helpers

private extension NetworkServiceImplTests {
    
    func response(code: Int) -> HTTPURLResponse {
        HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
        )!
    }
    
    func assertThrows(
        _ expected: NetworkError,
        for code: Int,
        line: UInt = #line
    ) {
        XCTAssertThrowsError(try service.validate(response(code: code)), line: line) { error in
            XCTAssertEqual(error as? NetworkError, expected, line: line)
        }
    }
}

final class SearchErrorMappingTests: XCTestCase {
    
    func test_init_mapsNetworkErrorsToDomainCases() {
        XCTAssertEqual(SearchError(NetworkError.unauthorized), .missingApiKey)
        XCTAssertEqual(SearchError(NetworkError.forbidden), .accessDenied)
        XCTAssertEqual(SearchError(NetworkError.noConnection), .noConnection)
        XCTAssertEqual(SearchError(NetworkError.quotaExceeded), .quotaExceeded)
        XCTAssertEqual(SearchError(NetworkError.rateLimited), .rateLimited)
        XCTAssertEqual(SearchError(NetworkError.decoding), .unknown)
    }
    
    func test_init_mapsUnknownErrorToUnknown() {
        struct SomeError: Error {}
        
        XCTAssertEqual(SearchError(SomeError()), .unknown)
    }
    
    func test_isRetryable_missingApiKeyCannotBeRetried() {
        XCTAssertFalse(SearchError.missingApiKey.isRetryable)
        XCTAssertFalse(SearchError.accessDenied.isRetryable)
        XCTAssertTrue(SearchError.noConnection.isRetryable)
    }
    
    func test_isRetryable_exhaustedQuotaCannotBeRetried() {
        XCTAssertFalse(SearchError.quotaExceeded.isRetryable)
        XCTAssertTrue(SearchError.rateLimited.isRetryable)
    }
}

final class ApiKeyProviderTests: XCTestCase {
    
    func test_key_placeholderValue_returnsNil() {
        let bundle = InfoDictionaryStub(value: "PUT_YOUR_RAPIDAPI_KEY_HERE")
        
        XCTAssertNil(ApiKeyProvider.key(for: "SpoonacularApiKey", bundle: bundle))
    }
    
    func test_key_emptyValue_returnsNil() {
        let bundle = InfoDictionaryStub(value: "")
        
        XCTAssertNil(ApiKeyProvider.key(for: "SpoonacularApiKey", bundle: bundle))
    }
    
    func test_key_realValue_returnsIt() {
        let bundle = InfoDictionaryStub(value: "abc123")
        
        XCTAssertEqual(ApiKeyProvider.key(for: "SpoonacularApiKey", bundle: bundle), "abc123")
    }
}

// MARK: - Info dictionary stub

private struct InfoDictionaryStub: InfoDictionaryProvider {
    
    let value: Any?
    
    func object(forInfoDictionaryKey key: String) -> Any? {
        value
    }
}
