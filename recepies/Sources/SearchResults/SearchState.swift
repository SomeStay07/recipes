import Foundation

struct SearchState: Equatable {
    
    let history: [String]
    let query: String
    let phase: Phase
    
    init(
        history: [String] = SearchState.mockHistory,
        query: String = "",
        phase: Phase = .idle
    ) {
        self.history = history
        self.query = query
        self.phase = phase
    }
    
    enum Phase: Equatable {
        case idle
        case loading
        case loaded([Recipe])
        case empty
        case failed(SearchError)
    }
}

// MARK: - Mock

extension SearchState {
    
    static let mockHistory: [String] = [
        "My search history",
        "My favourite recipes",
        "Easy Mexican Casserole",
        "Pasta carbonara",
        "Chocolate cake",
        "Greek salad",
        "Tom Yum soup"
    ]
}
