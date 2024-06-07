import SwiftUI

extension Font {
    static var heading1: Font {
        ThemeManager.shared.currentTheme.fonts.heading1
    }
    
    static var heading2: Font {
        ThemeManager.shared.currentTheme.fonts.heading2
    }
    
    static var heading3: Font {
        ThemeManager.shared.currentTheme.fonts.heading3
    }
    
    static var heading4: Font {
        ThemeManager.shared.currentTheme.fonts.heading4
    }
    
    static var title: Font {
        ThemeManager.shared.currentTheme.fonts.title
    }
    
    static var body: Font {
        ThemeManager.shared.currentTheme.fonts.body
    }
    
    static var description: Font {
        ThemeManager.shared.currentTheme.fonts.description
    }
    
    static var numbersS: Font {
        ThemeManager.shared.currentTheme.fonts.numbersS
    }
    
    static var numbersM: Font {
        ThemeManager.shared.currentTheme.fonts.numbersM
    }
}
