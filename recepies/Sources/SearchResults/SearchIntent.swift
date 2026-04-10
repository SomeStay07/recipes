import Foundation

enum SearchIntent: Equatable {
    case submit(String)
    case resultsLoaded([String])
    case clear
    case selectHistory(Int)
}
