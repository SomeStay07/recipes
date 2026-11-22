import SwiftUI

struct UIKitButtonSecondary: UIKitButtonType {
    let `default`: UIKitButtonAppearance = UIKitButtonSecondaryDefault()
    let enabled: UIKitButtonAppearance = UIKitButtonSecondaryEnabled()
    let pressed: UIKitButtonAppearance = UIKitButtonSecondaryPressed()
    let disabled: UIKitButtonAppearance = UIKitButtonSecondaryDisabled()
}

private struct UIKitButtonSecondaryDefault: UIKitButtonAppearance {
    let font: Font = .title
    let weight: Font.Weight = .regular
    let foregroundColor: Color = .label.primary
    let backgroundColor: Color = .background.primary
}

private struct UIKitButtonSecondaryEnabled: UIKitButtonAppearance {
    let font: Font = .title
    let weight: Font.Weight = .regular
    let foregroundColor: Color = .label.primary.opacity(0.9)
    let backgroundColor: Color = .background.primary.opacity(0.9)
}

private struct UIKitButtonSecondaryPressed: UIKitButtonAppearance {
    let font: Font = .title
    let weight: Font.Weight = .regular
    let foregroundColor: Color = .label.primary.opacity(0.4)
    let backgroundColor: Color = .red
}

private struct UIKitButtonSecondaryDisabled: UIKitButtonAppearance {
    let font: Font = .title
    let weight: Font.Weight = .regular
    let foregroundColor: Color = .gray.opacity(0.3)
    let backgroundColor: Color = .gray
}

extension UIKitButtonType where Self == UIKitButtonSecondary {
    static var secondary: UIKitButtonType { UIKitButtonSecondary() }
}
