import Foundation

extension Locale {
    static var preferredLanguageCode: String {
        guard
            let preferredLanguage = preferredLanguages.first,
            let code = Locale(identifier: preferredLanguage).language.languageCode?.identifier
        else {
            return "en"
        }
        
        return code
    }
    
    static var preferredLanguageCodes: [String] {
        Locale.preferredLanguages.compactMap({Locale(identifier: $0).language.languageCode?.identifier})
    }
}
