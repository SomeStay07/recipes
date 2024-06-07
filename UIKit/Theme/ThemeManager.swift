import SwiftUI

final class ThemeManager: ObservableObject {
    
    @Published var currentThemeType: ThemeTypes
    
    @Published var themes: [ThemeTypes: Theme]
    
    var currentTheme: Theme {
        themes[currentThemeType]!
    }
    
    static let shared = ThemeManager()
    
    private init(
        themes: [ThemeTypes: Theme] = [:],
        currentThemeType: ThemeTypes = .light
    ) {
        self.themes = themes
        self.currentThemeType = currentThemeType
    }
    
}
