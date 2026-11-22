import SwiftUI

enum MenuSectionType {
    case media
    case preferences
    case account

    var title: LocalizedStringKey {
        switch self {
        case .media: "settings.section.media"
        case .preferences: "settings.section.preferences"
        case .account: "settings.section.account"
        }
    }
}
