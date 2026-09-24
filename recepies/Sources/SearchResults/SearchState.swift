import Foundation

struct SearchState: Equatable {
    
    let history: [String]
    let phase: Phase
    
    init(
        history: [String] = SearchState.mockHistory,
        phase: Phase = .idle
    ) {
        self.history = history
        self.phase = phase
    }
    
    enum Phase: Equatable {
        case idle
        case loaded([String])
        case empty
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
