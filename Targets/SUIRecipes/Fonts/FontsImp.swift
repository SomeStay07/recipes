import SwiftUI

struct FontsImp: Fonts {
    
    let heading1: Font = interFont(size: 26)
    let heading2: Font = interFont(size: 24)
    let heading3: Font = interFont(size: 20)
    let heading4: Font = interFont(size: 18)
    
    let title: Font = interFont(size: 16, weight: .medium)
    let body: Font = interFont(size: 16)
    
    let description: Font = interFont(size: 14)
    let caption: Font = interFont(size: 12, weight: .thin)
    
    let numbersS: Font = interFont(size: 12, weight: .bold)
    let numbersM: Font = interFont(size: 16, weight: .heavy)
        
    static func interFont(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .custom(FontsCollection(weight: weight).rawValue, size: size)
    }
    
}

// MARK: - FontsCollection

enum FontsCollection: String {
    case thin = "Inter-Thin"
    case extraLight = "Inter-ExtraLight"
    case light = "Inter-Light"
    case regular = "Inter-Regular"
    case medium = "Inter-Medium"
    case semiBold = "Inter-SemiBold"
    case bold = "Inter-Bold"
    case extraBold = "Inter-ExtraBold"
    case black = "Inter-Black"
    
    init(weight: Font.Weight) {
        switch weight {
        case .thin: self = .thin
        case .ultraLight: self = .extraLight
        case .light: self = .light
        case .regular: self = .regular
        case .medium: self = .medium
        case .semibold: self = .semiBold
        case .bold: self = .bold
        case .heavy: self = .extraBold
        case .black: self = .black
        default: self = .regular
        }
    }
}
