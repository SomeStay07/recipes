import SwiftUI

extension Color {
    
    static var background: BackgroundColors {
       ThemeManager.shared.currentTheme.colors.background
    }
    
    static var label: LabelColors {
        ThemeManager.shared.currentTheme.colors.label
    }
    
    static var element: ElementColors {
        ThemeManager.shared.currentTheme.colors.element
    }
}
