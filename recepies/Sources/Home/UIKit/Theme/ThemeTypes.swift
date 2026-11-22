import SwiftUI

enum ThemeTypes: Int, Codable, CaseIterable, Identifiable {
    case unspecified
    case light
    case dark
    case newYear

    var id: Int { rawValue }

    init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .unspecified
        case 1: self = .light
        case 2: self = .dark
        case 3: self = .newYear
        default: self = .unspecified
        }
    }

    var displayName: LocalizedStringKey {
        switch self {
        case .unspecified:
            "theme.unspecified"
        case .light:
            "theme.light"
        case .dark:
            "theme.dark"
        case .newYear:
            "theme.newYear"
        }
    }
}
