import Foundation

// MARK: - InfoDictionaryProvider

protocol InfoDictionaryProvider {
    func object(forInfoDictionaryKey key: String) -> Any?
}

extension Bundle: InfoDictionaryProvider {}

// MARK: - ApiKeyProvider

enum ApiKeyProvider {
    
    private static let placeholder = "PUT_YOUR_RAPIDAPI_KEY_HERE"
    
    static var spoonacular: String? {
        key(for: "SpoonacularApiKey")
    }
    
    static func key(
        for field: String,
        bundle: InfoDictionaryProvider = Bundle.main
    ) -> String? {
        guard
            let value = bundle.object(forInfoDictionaryKey: field) as? String,
            value.isEmpty == false,
            value != placeholder
        else {
            return nil
        }
        
        return value
    }
}
