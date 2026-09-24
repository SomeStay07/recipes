import Foundation
import Observation

@Observable
final class SearchStore {
    
    private(set) var state: SearchState
    
    @ObservationIgnored
    private var searchTask: Task<Void, Never>?
    
    init(state: SearchState = SearchState()) {
        self.state = state
    }
    
    func send(_ intent: SearchIntent) {
        state = Self.reduce(state, intent)
        handleEffect(for: intent)
    }
    
    // MARK: - Pure reducer
    
    static func reduce(_ state: SearchState, _ intent: SearchIntent) -> SearchState {
        switch intent {
        case .submit(let query):
            return handleSubmit(state: state, query: query)
        case .resultsLoaded(let results):
            return handleResultsLoaded(state: state, results: results)
        case .clear:
            return handleClear(state: state)
        case .selectHistory(let index):
            return handleSelectHistory(state: state, index: index)
        }
    }
}

// MARK: - Pure handlers

private extension SearchStore {
    
    static func handleSubmit(state: SearchState, query: String) -> SearchState {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        return SearchState(
            history: state.history,
            phase: trimmed.isEmpty ? .idle : state.phase
        )
    }
    
    static func handleResultsLoaded(
        state: SearchState,
        results: [String]
    ) -> SearchState {
        SearchState(
            history: state.history,
            phase: results.isEmpty ? .empty : .loaded(results)
        )
    }
    
    static func handleClear(state: SearchState) -> SearchState {
        SearchState(
            history: state.history,
            phase: .idle
        )
    }
    
    static func handleSelectHistory(state: SearchState, index: Int) -> SearchState {
        guard state.history.indices.contains(index) else { return state }
        
        let picked = state.history[index]
        return SearchState(
            history: state.history,
            phase: .loaded([picked])
        )
    }
}

// MARK: - Side effects

private extension SearchStore {
    
    func handleEffect(for intent: SearchIntent) {
        switch intent {
        case .submit(let query):
            performSearch(query: query)
        case .resultsLoaded, .clear, .selectHistory:
            break
        }
    }
    
    func performSearch(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard trimmed.isEmpty == false else { return }
        
        searchTask?.cancel()
        searchTask = Task {
            let matches = state.history.filter {
                $0.localizedCaseInsensitiveContains(trimmed)
            }
            guard Task.isCancelled == false else { return }
            send(.resultsLoaded(matches))
        }
    }
}
