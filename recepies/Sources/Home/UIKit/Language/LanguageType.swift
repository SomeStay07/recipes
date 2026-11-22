import SwiftUI

enum LanguageType: String, CaseIterable, Identifiable {
    case system
    case ru
    case en

    var id: String { rawValue }

    var localeIdentifier: String? {
        self == .system ? nil : rawValue
    }

    var displayName: LocalizedStringKey {
        switch self {
        case .ru:
            "language.ru"
        case .en:
            "language.en"
        case .system:
            "language.system"
        }
    }
}

