import Foundation
import XCTest
@testable import recepies

final class SearchStoreTests: XCTestCase {
    
    // MARK: - submit
    
    func test_submit_nonEmpty_leavesPhaseUnchanged() {
        let initial = SearchState(history: ["pasta"], phase: .idle)
        let next = SearchStore.reduce(initial, .submit("pa"))
        XCTAssertEqual(next.phase, .idle)
    }
    
    func test_submit_emptyString_setsIdle() {
        let initial = SearchState(
            history: ["pasta"],
            phase: .loaded(["pasta"])
        )
        let next = SearchStore.reduce(initial, .submit("   "))
        XCTAssertEqual(next.phase, .idle)
    }
    
    // MARK: - resultsLoaded
    
    func test_resultsLoaded_withItems_setsLoaded() {
        let initial = SearchState(history: ["pasta", "pizza"], phase: .idle)
        let next = SearchStore.reduce(initial, .resultsLoaded(["pasta"]))
        XCTAssertEqual(next.phase, .loaded(["pasta"]))
    }
    
    func test_resultsLoaded_empty_setsEmpty() {
        let initial = SearchState(history: ["pasta"], phase: .idle)
        let next = SearchStore.reduce(initial, .resultsLoaded([]))
        XCTAssertEqual(next.phase, .empty)
    }
    
    // MARK: - clear
    
    func test_clear_setsIdle() {
        let initial = SearchState(
            history: ["pasta", "pizza"],
            phase: .loaded(["pasta"])
        )
        let next = SearchStore.reduce(initial, .clear)
        XCTAssertEqual(next.phase, .idle)
    }
    
    // MARK: - selectHistory
    
    func test_selectHistory_validIndex_setsLoadedWithSingleItem() {
        let initial = SearchState(history: ["pasta", "pizza", "salad"])
        let next = SearchStore.reduce(initial, .selectHistory(1))
        XCTAssertEqual(next.phase, .loaded(["pizza"]))
    }
    
    func test_selectHistory_outOfBounds_leavesStateUntouched() {
        let initial = SearchState(history: ["pasta"])
        let next = SearchStore.reduce(initial, .selectHistory(42))
        XCTAssertEqual(next, initial)
    }
}
