import SwiftUI

struct LightTheme: Theme {
    let colors: Colors = LightColors()
    var fonts: Fonts = FontsImp()
}

struct LightColors: Colors {
    let background: BackgroundColors = LightBackgroundColors()
    let label: LabelColors = LightLabelColors()
    let element: ElementColors = LightElementColors()
}

struct LightBackgroundColors: BackgroundColors {
    let primary: Color = Color(hex: "FFF8ED")       // мягкий кремовый фон
    let secondary: Color = Color(hex: "FFF3E0")     // чуть светлее
    let ghost: Color = Color(hex: "4D000000")       // полупрозрачный чёрный для теней
    let tertiaty: Color = Color(hex: "FFB74D")      // тёплый оранжевый оттенок
    let accent: Color = Color(hex: "FFA726")        // яркий оранжевый для акцентов
    let overlay: Color = Color(hex: "80FFFFFF")     // прозрачный белый для наложений
}

struct LightLabelColors: LabelColors {
    let primary: Color = Color(hex: "424242")       // насыщенный тёмно-серый текст
    let secondary: Color = Color(hex: "6D4C41")     // коричневый (приятный для рецептов)
    let tertiary: Color = Color(hex: "FF9800")      // оранжевый для выделения
    let highlight: Color = Color(hex: "FFE082")     // пастельный жёлтый (подсветка)
    let muted: Color = Color(hex: "9E9E9E")         // приглушённый серый
}

struct LightElementColors: ElementColors {
    let primary: Color = Color(hex: "FFA726")       // оранжевая кнопка
    let secondary: Color = Color(hex: "FFB74D")     // более светлый оранжевый для иконок
    let tertiary: Color = Color(hex: "8D6E63")      // коричневый (доп. элементы, фоны карточек)
}
