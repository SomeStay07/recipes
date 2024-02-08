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
    let primary: Color = .red
    let secondary: Color = .red.opacity(0.5)
    let ghost: Color = .gray.opacity(0.6)
}

struct LightLabelColors: LabelColors {
    let primary: Color = .yellow
    let secondary: Color = .yellow.opacity(0.5)
    let tertiary: Color = .gray.opacity(0.8)
}
