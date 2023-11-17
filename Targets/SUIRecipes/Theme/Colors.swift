import SwiftUI

protocol Colors {
    var background: BackgroundColors { get }
    var label: LabelColors { get }
}

protocol BackgroundColors {
    var primary: Color { get }
    var secondary: Color { get }
}

protocol LabelColors {
    var primary: Color { get }
    var secondary: Color { get }
}
