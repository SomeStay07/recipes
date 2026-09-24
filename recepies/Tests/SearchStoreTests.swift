import Foundation
import XCTest
@testable import recepies

final class SearchStoreTests: XCTestCase {
    
    // MARK: - submit
    
    func test_submit_nonEmpty_setsLoadingAndKeepsQuery() {
        let initial = SearchState(history: ["pasta"], phase: .idle)
        let next = SearchStore.reduce(initial, .submit("  pa  "))
        XCTAssertEqual(next.phase, .loading)
        XCTAssertEqual(next.query, "pa")
    }
    
    func test_submit_emptyString_setsIdle() {
        let initial = SearchState(
            history: ["pasta"],
            query: "pasta",
            phase: .loaded([.stub(id: 1)])
        )
        let next = SearchStore.reduce(initial, .submit("   "))
        XCTAssertEqual(next.phase, .idle)
        XCTAssertEqual(next.query, "")
    }
    
    // MARK: - resultsLoaded
    
    func test_resultsLoaded_withItems_setsLoaded() {
        let recipe = Recipe.stub(id: 1)
        let initial = SearchState(history: ["pasta"], query: "pasta", phase: .loading)
        let next = SearchStore.reduce(initial, .resultsLoaded([recipe]))
        XCTAssertEqual(next.phase, .loaded([recipe]))
    }
    
    func test_resultsLoaded_empty_setsEmpty() {
        let initial = SearchState(history: ["pasta"], query: "pasta", phase: .loading)
        let next = SearchStore.reduce(initial, .resultsLoaded([]))
        XCTAssertEqual(next.phase, .empty)
    }
    
    // MARK: - failed
    
    func test_failed_setsFailedAndKeepsQuery() {
        let initial = SearchState(history: ["pasta"], query: "pasta", phase: .loading)
        let next = SearchStore.reduce(initial, .failed(.noConnection))
        XCTAssertEqual(next.phase, .failed(.noConnection))
        XCTAssertEqual(next.query, "pasta")
    }
    
    // MARK: - retry
    
    func test_retry_withQuery_setsLoading() {
        let initial = SearchState(
            history: ["pasta"],
            query: "pasta",
            phase: .failed(.noConnection)
        )
        let next = SearchStore.reduce(initial, .retry)
        XCTAssertEqual(next.phase, .loading)
    }
    
    func test_retry_withoutQuery_leavesStateUntouched() {
        let initial = SearchState(history: ["pasta"], query: "", phase: .failed(.unknown))
        let next = SearchStore.reduce(initial, .retry)
        XCTAssertEqual(next, initial)
    }
    
    // MARK: - clear
    
    func test_clear_setsIdleAndDropsQuery() {
        let initial = SearchState(
            history: ["pasta", "pizza"],
            query: "pasta",
            phase: .loaded([.stub(id: 1)])
        )
        let next = SearchStore.reduce(initial, .clear)
        XCTAssertEqual(next.phase, .idle)
        XCTAssertEqual(next.query, "")
    }
    
    // MARK: - selectHistory
    
    func test_selectHistory_validIndex_setsLoadingWithPickedQuery() {
        let initial = SearchState(history: ["pasta", "pizza", "salad"])
        let next = SearchStore.reduce(initial, .selectHistory(1))
        XCTAssertEqual(next.phase, .loading)
        XCTAssertEqual(next.query, "pizza")
    }
    
    func test_selectHistory_outOfBounds_leavesStateUntouched() {
        let initial = SearchState(history: ["pasta"])
        let next = SearchStore.reduce(initial, .selectHistory(42))
        XCTAssertEqual(next, initial)
    }
}

// MARK: - Side effects

@MainActor
final class SearchStoreEffectTests: XCTestCase {
    
    func test_submit_successfulSearch_setsLoadedWithRecipes() async throws {
        let recipe = Recipe.stub(id: 7, title: "Pasta carbonara")
        let service = RecipeSearchServiceMock(result: .success([recipe]))
        let store = SearchStore(service: service)
        
        store.send(.submit("pasta"))
        XCTAssertEqual(store.state.phase, .loading)
        
        try await waitUntilSettled(store)
        XCTAssertEqual(store.state.phase, .loaded([recipe]))
        XCTAssertEqual(service.receivedQueries, ["pasta"])
    }
    
    func test_submit_emptyResponse_setsEmpty() async throws {
        let service = RecipeSearchServiceMock(result: .success([]))
        let store = SearchStore(service: service)
        
        store.send(.submit("pasta"))
        try await waitUntilSettled(store)
        
        XCTAssertEqual(store.state.phase, .empty)
    }
    
    func test_submit_networkFailure_setsMappedError() async throws {
        let service = RecipeSearchServiceMock(result: .failure(NetworkError.quotaExceeded))
        let store = SearchStore(service: service)
        
        store.send(.submit("pasta"))
        try await waitUntilSettled(store)
        
        XCTAssertEqual(store.state.phase, .failed(.quotaExceeded))
    }
    
    func test_retry_afterFailure_repeatsTheSameQuery() async throws {
        let service = RecipeSearchServiceMock(result: .failure(NetworkError.noConnection))
        let store = SearchStore(service: service)
        
        store.send(.submit("pasta"))
        try await waitUntilSettled(store)
        XCTAssertEqual(store.state.phase, .failed(.noConnection))
        
        let recipe = Recipe.stub(id: 1)
        service.result = .success([recipe])
        store.send(.retry)
        try await waitUntilSettled(store)
        
        XCTAssertEqual(store.state.phase, .loaded([recipe]))
        XCTAssertEqual(service.receivedQueries, ["pasta", "pasta"])
    }
    
    func test_submit_emptyQuery_doesNotCallService() async throws {
        let service = RecipeSearchServiceMock(result: .success([]))
        let store = SearchStore(service: service)
        
        store.send(.submit("   "))
        try await waitUntilSettled(store)
        
        XCTAssertEqual(store.state.phase, .idle)
        XCTAssertTrue(service.receivedQueries.isEmpty)
    }
    
    func test_clear_afterSubmit_keepsIdleDespiteInFlightSearch() async throws {
        let service = RecipeSearchServiceMock(result: .success([.stub(id: 1)]))
        service.delay = .milliseconds(50)
        let store = SearchStore(service: service)
        
        store.send(.submit("pasta"))
        store.send(.clear)
        try await waitUntilSettled(store)
        
        XCTAssertEqual(store.state.phase, .idle)
    }

    func test_secondSearch_winsOverSlowerFirstOne() async throws {
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
        let store = SearchStore(service: service)
        
        store.send(.submit("pasta"))
        store.send(.submit("pizza"))
        
        try await waitUntilSettled(store)
        try await Task.sleep(for: .milliseconds(500))
        
        XCTAssertEqual(store.state.phase, .loaded([pizza]))
        XCTAssertEqual(store.state.query, "pizza")
    }
    
    func test_ownCancellation_leavesScreenToTheNewSearch() async throws {
        let pizza = Recipe.stub(id: 2, title: "Pizza margherita")
        let service = RecipeSearchServiceMock(result: .success([pizza]))
        service.delaysByQuery = ["pasta": .milliseconds(300)]
        let store = SearchStore(service: service)
        
        store.send(.submit("pasta"))
        store.send(.clear)
        
        try await Task.sleep(for: .milliseconds(400))
        
        // Отменённый поиск молчит: экран остался там, куда его увёл clear
        XCTAssertEqual(store.state.phase, .idle)
    }
    
    func test_foreignCancellation_becomesVisibleError() async throws {
        let service = RecipeSearchServiceMock(
            result: .failure(URLError(.cancelled))
        )
        let store = SearchStore(service: service)
        
        store.send(.submit("pasta"))
        try await waitUntilSettled(store)
        
        // Отмену, которую мы не запускали, показываем: вечный спиннер хуже ошибки
        XCTAssertEqual(store.state.phase, .failed(.unknown))
    }
    
    func test_isCancellation_recognisesAllThreeShapes() {
        XCTAssertTrue(SearchStore.isCancellation(CancellationError()))
        XCTAssertTrue(SearchStore.isCancellation(NetworkError.cancelled))
        XCTAssertTrue(SearchStore.isCancellation(URLError(.cancelled)))
        XCTAssertFalse(SearchStore.isCancellation(NetworkError.noConnection))
        XCTAssertFalse(SearchStore.isCancellation(URLError(.timedOut)))
    }
}

// MARK: - Helpers

private extension SearchStoreEffectTests {
    
    func waitUntilSettled(
        _ store: SearchStore,
        timeout: Duration = .seconds(2)
    ) async throws {
        let deadline = ContinuousClock.now.advanced(by: timeout)
        
        while store.state.phase == .loading, ContinuousClock.now < deadline {
            try await Task.sleep(for: .milliseconds(10))
        }
        
        try await Task.sleep(for: .milliseconds(20))
        
        XCTAssertNotEqual(
            store.state.phase,
            .loading,
            "Стор так и не вышел из loading за \(timeout)"
        )
    }
}

// MARK: - Mock

final class RecipeSearchServiceMock: RecipeSearchService, @unchecked Sendable {
    
    var result: Result<[Recipe], Error>
    var delay: Duration?
    var resultsByQuery: [String: [Recipe]] = [:]
    var delaysByQuery: [String: Duration] = [:]
    private(set) var receivedQueries: [String] = []
    
    init(result: Result<[Recipe], Error>) {
        self.result = result
    }
    
    func search(query: String) async throws -> [Recipe] {
        receivedQueries.append(query)
        
        if let delay = delaysByQuery[query] ?? delay {
            try await Task.sleep(for: delay)
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
