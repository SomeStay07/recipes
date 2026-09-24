import Foundation
import Observation

@MainActor
@Observable
final class SearchStore {
    
    private(set) var state: SearchState
    
    @ObservationIgnored
    private let service: RecipeSearchService
    
    @ObservationIgnored
    private var searchTask: Task<Void, Never>?
    
    init(
        state: SearchState = SearchState(),
        service: RecipeSearchService = SpoonacularSearchService()
    ) {
        self.state = state
        self.service = service
    }
    
    func send(_ intent: SearchIntent) {
        state = Self.reduce(state, intent)
        handleEffect(for: intent)
    }
    
    // MARK: - Pure reducer
    
    nonisolated static func reduce(_ state: SearchState, _ intent: SearchIntent) -> SearchState {
        switch intent {
        case .submit(let query):
            return handleSubmit(state: state, query: query)
        case .resultsLoaded(let results):
            return handleResultsLoaded(state: state, results: results)
        case .failed(let error):
            return handleFailed(state: state, error: error)
        case .retry:
            return handleRetry(state: state)
        case .clear:
            return handleClear(state: state)
        case .selectHistory(let index):
            return handleSelectHistory(state: state, index: index)
        }
    }
}

// MARK: - Pure handlers

private extension SearchStore {
    
    nonisolated static func handleSubmit(state: SearchState, query: String) -> SearchState {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        
        guard trimmed.isEmpty == false else {
            return SearchState(
                history: state.history,
                query: "",
                phase: .idle
            )
        }
        
        return SearchState(
            history: state.history,
            query: trimmed,
            phase: .loading
        )
    }
    
    nonisolated static func handleResultsLoaded(
        state: SearchState,
        results: [Recipe]
    ) -> SearchState {
        SearchState(
            history: state.history,
            query: state.query,
            phase: results.isEmpty ? .empty : .loaded(results)
        )
    }
    
    nonisolated static func handleFailed(
        state: SearchState,
        error: SearchError
    ) -> SearchState {
        SearchState(
            history: state.history,
            query: state.query,
            phase: .failed(error)
        )
    }
    
    nonisolated static func handleRetry(state: SearchState) -> SearchState {
        guard state.query.isEmpty == false else { return state }
        
        return SearchState(
            history: state.history,
            query: state.query,
            phase: .loading
        )
    }
    
    nonisolated static func handleClear(state: SearchState) -> SearchState {
        SearchState(
            history: state.history,
            query: "",
            phase: .idle
        )
    }
    
    nonisolated static func handleSelectHistory(state: SearchState, index: Int) -> SearchState {
        guard state.history.indices.contains(index) else { return state }
        
        return SearchState(
            history: state.history,
            query: state.history[index],
            phase: .loading
        )
    }
}

// MARK: - Side effects

private extension SearchStore {
    
    func handleEffect(for intent: SearchIntent) {
        switch intent {
        case .submit, .retry, .selectHistory:
            performSearch()
        case .clear:
            searchTask?.cancel()
            searchTask = nil
        case .resultsLoaded, .failed:
            break
        }
    }
    
    func performSearch() {
        searchTask?.cancel()
        
        guard state.phase == .loading else { return }
        
        let query = state.query
        
        searchTask = Task { [weak self, service] in
            do {
                let recipes = try await service.search(query: query)
                guard Task.isCancelled == false else { return }
                self?.send(.resultsLoaded(recipes))
            } catch {
                // Свою отмену узнаём по флагу задачи: URLSession в этот момент
                // бросает URLError.cancelled, и показывать его экрану нельзя.
                // Отмена, которую мы не запускали, остаётся честной ошибкой:
                // иначе экран навсегда застрянет на спиннере.
                guard Task.isCancelled == false else { return }
                
                self?.send(.failed(SearchError(error)))
            }
        }
    }
}

// MARK: - Cancellation

extension SearchStore {
    
    // Отмену приносят три разных типа: URLSession бросает URLError.cancelled,
    // сетевой слой переводит его в NetworkError.cancelled, а sleep и прочие
    // точки ожидания бросают CancellationError.
    nonisolated static func isCancellation(_ error: Error) -> Bool {
        switch error {
        case is CancellationError:
            return true
        case let error as NetworkError where error == .cancelled:
            return true
        case let error as URLError where error.code == .cancelled:
            return true
        default:
            return false
        }
    }
}
