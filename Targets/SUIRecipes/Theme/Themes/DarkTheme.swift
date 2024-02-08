import SwiftUI

struct DarkTheme: Theme {
    let colors: Colors = DarkColors()
    var fonts: Fonts = FontsImp()
}

struct DarkColors: Colors {
    let background: BackgroundColors = DarkBackgroundColors()
    let label: LabelColors = DarkLabelColors()
}

struct DarkBackgroundColors: BackgroundColors {
    let primary: Color = .blue
    let secondary: Color = .blue.opacity(0.5)
    let ghost: Color = .gray.opacity(0.6)
}

struct DarkLabelColors: LabelColors {
    let primary: Color = .green
    let secondary: Color = .green.opacity(0.5)
    let tertiary: Color = .gray.opacity(0.8)
}
