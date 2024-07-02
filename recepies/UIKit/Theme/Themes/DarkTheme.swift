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
    let primary: Color = .white
    let secondary: Color = .secondary
    let ghost: Color = .gray
    let tertiaty: Color = .gray.opacity(0.2)
}

struct DarkLabelColors: LabelColors {
    let primary: Color = .primary
    let secondary: Color = .secondary
    let tertiary: Color = Color(UIColor.lightGray)
}
