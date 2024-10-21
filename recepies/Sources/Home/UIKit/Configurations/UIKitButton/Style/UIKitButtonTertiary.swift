import SwiftUI

struct UIKitButtonTertiary: UIKitButtonType {
    let `default`: UIKitButtonAppearance = UIKitButtonTertiaryDefault()
    let enabled: UIKitButtonAppearance = UIKitButtonTertiaryEnabled()
    let pressed: UIKitButtonAppearance = UIKitButtonTertiaryPressed()
    let disabled: UIKitButtonAppearance = UIKitButtonTertiaryDisabled()
}

private struct UIKitButtonTertiaryDefault: UIKitButtonAppearance {
    let font: Font = .title
    let weight: Font.Weight = .regular
    let foregroundColor: Color = .label.primary
    let backgroundColor: Color = .background.primary
}

private struct UIKitButtonTertiaryEnabled: UIKitButtonAppearance {
    let font: Font = .title
    let weight: Font.Weight = .regular
    let foregroundColor: Color = .label.primary.opacity(0.9)
    let backgroundColor: Color = .background.primary.opacity(0.9)
}

private struct UIKitButtonTertiaryPressed: UIKitButtonAppearance {
    let font: Font = .title
    let weight: Font.Weight = .regular
    let foregroundColor: Color = .label.primary.opacity(0.4)
    let backgroundColor: Color = .red
}

private struct UIKitButtonTertiaryDisabled: UIKitButtonAppearance {
    let font: Font = .title
    let weight: Font.Weight = .regular
    let foregroundColor: Color = .gray.opacity(0.3)
    let backgroundColor: Color = .gray
}

extension UIKitButtonType where Self == UIKitButtonTertiary {
    static var tertiary: UIKitButtonType { UIKitButtonTertiary() }
}
