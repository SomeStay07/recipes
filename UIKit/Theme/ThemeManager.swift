import SwiftUI

final class ThemeManager: ObservableObject {
    
    @AppStorage(ThemeManager.name) var currentThemeType: ThemeTypes = .unspecified
    
    @Published var themes: [ThemeTypes: Theme]
    @Published var isSystemDarkOn: Bool
    
    var currentTheme: Theme {
        if currentThemeType == .unspecified {
            return isSystemDarkOn ? themes[.dark]! : themes[.light]!
        }
        
        return themes[currentThemeType]!
    }
    
    static let shared = ThemeManager(
        themes: [:],
        currentThemeType: .unspecified,
        isSystemDarkOn: false
    )
    
    private init(
        themes: [ThemeTypes: Theme],
        currentThemeType: ThemeTypes,
        isSystemDarkOn: Bool
    ) {
        self.themes = themes
        self.currentThemeType = currentThemeType
        self.isSystemDarkOn = isSystemDarkOn
    }
    
}

extension ThemeManager {
    static var name = "appTheme"
}
