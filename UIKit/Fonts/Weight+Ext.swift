import UIKit
import SwiftUI

// MARK: - With weight

extension UIFont {
    public func withWeight(_ weight: UIFont.Weight) -> UIFont {
        var attributes = fontDescriptor.fontAttributes
        var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]

        traits[.weight] = weight

        attributes[.name] = nil
        attributes[.traits] = traits
        attributes[.family] = familyName

        let descriptor = UIFontDescriptor(fontAttributes: attributes)

        return UIFont(descriptor: descriptor, size: pointSize)
    }
}

// MARK: - Weight

extension UIFont {
    var weight: Weight {
        guard let weightNumber = traits[.weight] as? CGFloat else {
            return .regular
        }
        
        return UIFont.Weight(rawValue: weightNumber)
    }
    
    var traits: [UIFontDescriptor.TraitKey: Any] {
        (fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
    }
}

extension Font.Weight {
    var uiWeight: UIFont.Weight? {
        switch self {
        case .thin: return .thin
        case .ultraLight: return .ultraLight
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        default: return nil
        }
    }
}

extension UIFont.Weight {
    
    enum Inter {
        static let thin = UIFont(name: FontsCollection.thin.rawValue, size: UIFont.systemFontSize)!.weight
        static let extraLight = UIFont(name: FontsCollection.extraLight.rawValue, size: UIFont.systemFontSize)!.weight
        static let light = UIFont(name: FontsCollection.light.rawValue, size: UIFont.systemFontSize)!.weight
        static let regular = UIFont(name: FontsCollection.regular.rawValue, size: UIFont.systemFontSize)!.weight
        static let medium = UIFont(name: FontsCollection.medium.rawValue, size: UIFont.systemFontSize)!.weight
        static let semiBold = UIFont(name: FontsCollection.semiBold.rawValue, size: UIFont.systemFontSize)!.weight
        static let bold = UIFont(name: FontsCollection.bold.rawValue, size: UIFont.systemFontSize)!.weight
        static let extraBold = UIFont(name: FontsCollection.extraBold.rawValue, size: UIFont.systemFontSize)!.weight
        static let black = UIFont(name: FontsCollection.black.rawValue, size: UIFont.systemFontSize)!.weight
    }
    
    var inter: UIFont.Weight {
        switch self {
        case .thin: return .Inter.thin
        case .ultraLight: return .Inter.extraLight
        case .light: return .Inter.light
        case .regular: return .Inter.regular
        case .medium: return .Inter.medium
        case .semibold: return .Inter.semiBold
        case .bold: return .Inter.bold
        case .heavy: return .Inter.extraBold
        case .black: return .Inter.black
        default: return self
        }
    }
    
}
