import SwiftUI

protocol Colors {
    var background: BackgroundColors { get }
    var label: LabelColors { get }
    var element: ElementColors { get }
}

protocol BackgroundColors {
    var primary: Color { get }
    var secondary: Color { get }
    var ghost: Color { get }
    var tertiaty: Color { get }
    var accent: Color { get }
    var overlay: Color { get }
}

protocol LabelColors {
    var primary: Color { get }
    var secondary: Color { get }
    var tertiary: Color { get }
    var highlight: Color { get }
    var muted: Color { get }
}

protocol ElementColors {
    var primary: Color { get }
    var secondary: Color { get }
    var tertiary: Color { get }
}
