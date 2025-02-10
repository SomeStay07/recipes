import SwiftUI

struct NewYearTheme: Theme {
    let colors: Colors = NewYearColors()
    var fonts: Fonts = FontsImp()
}

struct NewYearColors: Colors {
    let background: BackgroundColors = NewYearBackgroundColors()
    let label: LabelColors = NewYearLabelColors()
    let element: ElementColors = NewYearElementColors()
}

struct NewYearBackgroundColors: BackgroundColors {
    let primary: Color = Color(hex: "0D1B2A")       // тёмно-синий
    let secondary: Color = Color(hex: "1B263B")     // чуть светлее
    let ghost: Color = Color(hex: "80FFFFFF")       // полупрозрачный белый
    let tertiaty: Color = Color(hex: "FFD700")      // золото (праздник)
    let accent: Color = Color(hex: "E53935")        // ярко-красный для акцентов
    let overlay: Color = Color.black.opacity(0.4)   // подложка
}

struct NewYearLabelColors: LabelColors {
    let primary: Color = Color(hex: "FFFFFF")       // белый текст
    let secondary: Color = Color(hex: "FFD700")     // золотой
    let tertiary: Color = Color(hex: "E53935")      // красный (для важного)
    let highlight: Color = Color(hex: "43A047")     // зелёный (рождественский)
    let muted: Color = Color(hex: "B0BEC5")         // серовато-голубой
}

struct NewYearElementColors: ElementColors {
    let primary: Color = Color(hex: "FFD700")       // золотой
    let secondary: Color = Color(hex: "E53935")     // красный
    let tertiary: Color = Color(hex: "1E88E5")      // более яркий синий для интерактивных деталей
}
