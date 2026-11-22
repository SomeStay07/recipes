import SwiftUI

final class LanguageManager: ObservableObject {
    @AppStorage(LanguageManager.name) var currentLanguage: LanguageType = .system
    
    static let shared = LanguageManager()
    
    private init() {}
    
    var selectedLanguage: Locale {
        guard let identifier = currentLanguage.localeIdentifier else {
            return Locale(identifier: Locale.preferredLanguageCode)
        }
        
        return Locale(identifier: identifier)
    }
}

extension LanguageManager {
    static var name = "appLanguage"
}
