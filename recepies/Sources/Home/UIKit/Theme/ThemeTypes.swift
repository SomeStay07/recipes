import Foundation

enum ThemeTypes: Int, Codable {
    case unspecified
    case light
    case dark
    
    init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .unspecified
        case 1: self = .light
        case 2: self = .dark
        default: self = .unspecified
        }
    }
}
