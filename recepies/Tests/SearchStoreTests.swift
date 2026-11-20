import Foundation
import Testing
@testable import recepies

@MainActor
struct SearchStoreTests {
    
    @Test func submitStartsLoadingAndKeepsQuery() {
        let state = SearchStore.reduce(SearchState(), .submit("  pasta  "))
        
        #expect(state.phase == .loading)
        #expect(state.query == "pasta")
    }
    
    @Test func searchGoesFromLoadingToLoaded() async throws {
        let pasta = Recipe.stub(id: 1, title: "Pasta carbonara")
        let service = RecipeSearchServiceMock(result: .success([pasta]))
        service.delay = .milliseconds(50)
        let store = SearchStore(service: service)
        
        store.send(.submit("pasta"))
        #expect(store.state.phase == .loading)
        
        try await waitUntilSettled(store)
        #expect(store.state.phase == .loaded([pasta]))
    }
    
    @Test func secondSearchWinsOverSlowerFirstOne() async throws {
        let pizza = Recipe.stub(id: 2, title: "Pizza margherita")
        let service = RecipeSearchServiceMock(result: .success([]))
        service.resultsByQuery = [
            "pasta": [.stub(id: 1, title: "Pasta carbonara")],
            "pizza": [pizza]
        ]
        service.delaysByQuery = [
            "pasta": .milliseconds(400),
            "pizza": .milliseconds(20)
        ]
        service.ignoresCancellation = true
        let store = SearchStore(service: service)
        
        store.send(.submit("pasta"))
        store.send(.submit("pizza"))
        
        try await Task.sleep(for: .milliseconds(500))
        
        #expect(store.state.phase == .loaded([pizza]))
    }
    
    @Test func ownCancellationKeepsScreenIdle() async throws {
        let service = RecipeSearchServiceMock(result: .success([.stub(id: 1)]))
        service.delay = .milliseconds(300)
        let store = SearchStore(service: service)
        
        store.send(.submit("pasta"))
        store.send(.clear)
        
        try await Task.sleep(for: .milliseconds(400))
        
        #expect(store.state.phase == .idle)
    }
    
    @Test func foreignCancellationBecomesError() async throws {
        let service = RecipeSearchServiceMock(result: .failure(URLError(.cancelled)))
        let store = SearchStore(service: service)
        
        store.send(.submit("pasta"))
        try await waitUntilSettled(store)
        
        #expect(store.state.phase == .failed(.unknown))
    }
}

// MARK: - Helpers

@MainActor
private func waitUntilSettled(
    _ store: SearchStore,
    timeout: Duration = .seconds(2)
) async throws {
    let deadline = ContinuousClock.now.advanced(by: timeout)
    
    while store.state.phase == .loading, ContinuousClock.now < deadline {
        try await Task.sleep(for: .milliseconds(10))
    }
    
    #expect(store.state.phase != .loading, "Стор так и не вышел из loading")
}

// MARK: - Mock

final class RecipeSearchServiceMock: RecipeSearchService, @unchecked Sendable {
    
    var result: Result<[Recipe], Error>
    var delay: Duration?
    var resultsByQuery: [String: [Recipe]] = [:]
    var delaysByQuery: [String: Duration] = [:]
    var ignoresCancellation = false
    private(set) var receivedQueries: [String] = []
    
    init(result: Result<[Recipe], Error>) {
        self.result = result
    }
    
    func search(query: String) async throws -> [Recipe] {
        receivedQueries.append(query)
        
        if let delay = delaysByQuery[query] ?? delay {
            if ignoresCancellation {
                await Task.detached { try? await Task.sleep(for: delay) }.value
            } else {
                try await Task.sleep(for: delay)
            }
        }
        
        if let recipes = resultsByQuery[query] {
            return recipes
        }
        
        return try result.get()
    }
}

// MARK: - Stub

extension Recipe {
    
    static func stub(
        id: Int,
        title: String = "Recipe",
        image: URL? = nil
    ) -> Recipe {
        Recipe(id: id, title: title, image: image, imageType: "jpg")
    }
}
