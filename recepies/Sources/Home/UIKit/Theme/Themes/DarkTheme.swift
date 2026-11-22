import SwiftUI

struct DarkTheme: Theme {
    let colors: Colors = DarkColors()
    var fonts: Fonts = FontsImp()
}

struct DarkColors: Colors {
    let background: BackgroundColors = DarkBackgroundColors()
    let label: LabelColors = DarkLabelColors()
    let element: ElementColors = DarkElementColors()
}

struct DarkBackgroundColors: BackgroundColors {
    let primary: Color = Color(hex: "1C1C1C")       // глубокий тёмный фон
    let secondary: Color = Color(hex: "2A2A2A")     // немного светлее
    let ghost: Color = Color(hex: "4DFFFFFF")       // полупрозрачный белый для градиентов/тумана
    let tertiaty: Color = Color(hex: "A84300")      // тёплый коричневый оттенок (специи)
    let accent: Color = Color(hex: "FFC107")        // золотистый акцент (например, иконки, кнопки)
    let overlay: Color = Color(hex: "80000000")     // тёмная подложка
}

struct DarkLabelColors: LabelColors {
    let primary: Color = Color(hex: "F0F0F0")       // светлый текст
    let secondary: Color = Color(hex: "FFC107")     // золотистый акцент
    let tertiary: Color = Color(hex: "FFA726")      // мягкий оранжевый
    let highlight: Color = Color(hex: "C8E6C9")     // пастельный зелёный (акцент на свежие продукты)
    let muted: Color = Color(hex: "BDBDBD")         // приглушённый серый
}

struct DarkElementColors: ElementColors {
    let primary: Color = Color(hex: "FFC107")       // тот же золотистый для главных кнопок
    let secondary: Color = Color(hex: "FFA726")     // оранжевый для дополнительного акцента
    let tertiary: Color = Color(hex: "6D4C41")      // коричневый (например, для иконок блюд)
}
