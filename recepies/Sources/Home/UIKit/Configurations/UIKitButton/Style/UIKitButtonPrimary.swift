import SwiftUI

struct UIKitButtonPrimary: UIKitButtonType {
    let `default`: UIKitButtonAppearance = UIKitButtonPrimaryDefault()
    let enabled: UIKitButtonAppearance = UIKitButtonPrimaryEnabled()
    let pressed: UIKitButtonAppearance = UIKitButtonPrimaryPressed()
    let disabled: UIKitButtonAppearance = UIKitButtonPrimaryDisabled()
}

private struct UIKitButtonPrimaryDefault: UIKitButtonAppearance {
    let font: Font = .title
    let weight: Font.Weight = .regular
    let foregroundColor: Color = .label.primary
    let backgroundColor: Color = .background.primary
}

private struct UIKitButtonPrimaryEnabled: UIKitButtonAppearance {
    let font: Font = .title
    let weight: Font.Weight = .regular
    let foregroundColor: Color = .label.primary
    let backgroundColor: Color = .background.primary
}

private struct UIKitButtonPrimaryPressed: UIKitButtonAppearance {
    let font: Font = .title
    let weight: Font.Weight = .regular
    let foregroundColor: Color = .label.secondary
    let backgroundColor: Color = .background.secondary
}

private struct UIKitButtonPrimaryDisabled: UIKitButtonAppearance {
    let font: Font = .title
    let weight: Font.Weight = .regular
    let foregroundColor: Color = .label.tertiary
    let backgroundColor: Color = .background.ghost
}

extension UIKitButtonType where Self == UIKitButtonPrimary {
    static var primary: UIKitButtonType { UIKitButtonPrimary() }
}
