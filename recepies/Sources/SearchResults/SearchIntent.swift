import Foundation

enum SearchIntent: Equatable {
    case submit(String)
    case resultsLoaded([Recipe])
    case failed(SearchError)
    case retry
    case clear
    case selectHistory(Int)
}
