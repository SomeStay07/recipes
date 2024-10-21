import Foundation

enum MenuSectionType {
    case media
    case preferences
    case account
    
    var title: String {
        switch self {
        case .media: return "Media"
        case .preferences: return "Preferences"
        case .account: return "Account"
        }
    }
}
