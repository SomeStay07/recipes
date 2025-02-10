import Foundation

enum LanguageType: String, CaseIterable, Identifiable {
    case system
    case ru
    case en
    
    var id: String { rawValue }
    
    var localeIdentifier: String? {
        self == .system ? nil : rawValue
    }
    
    var displayName: String {
        switch self {
        case .ru:
            "Русский"
        case .en:
            "English"
        default:
            "Системная"
        }
    }
}

