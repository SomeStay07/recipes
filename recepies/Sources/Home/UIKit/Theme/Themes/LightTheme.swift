import SwiftUI

struct LightTheme: Theme {
    let colors: Colors = LightColors()
    var fonts: Fonts = FontsImp()
}

struct LightColors: Colors {
    let background: BackgroundColors = LightBackgroundColors()
    let label: LabelColors = LightLabelColors()
}

struct LightBackgroundColors: BackgroundColors {
    let primary: Color = .primary
    let secondary: Color = .secondary
    let ghost: Color = .gray
    let tertiaty: Color = .gray.opacity(0.2)
}

struct LightLabelColors: LabelColors {
    let primary: Color = .white
    let secondary: Color = .gray
    let tertiary: Color = .gray.opacity(0.8)
}
