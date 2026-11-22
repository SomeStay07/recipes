import Foundation

struct MenuSection {
    let type: MenuSectionType
    let items: [MenuItemType]
}

enum MenuItemType {
    case wishlist
    case download
    case theme
    case language
    case logout
    case privacy
    case version(String)
}
