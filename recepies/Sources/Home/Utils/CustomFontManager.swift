import UIKit

class CustomFontManager {
    
    static func registerCustomFonts() {
        let fontURLs = fetchFontURLs(withExtension: "otf", inSubdirectory: "Resources/Fonts")
        
        fontURLs.forEach { url in
            if !registerFont(from: url) {
                print("Failed to register font at: \(url)")
            }
        }
    }
    
    private static func fetchFontURLs(withExtension: String, inSubdirectory subdirectory: String?) -> [URL] {
        return Bundle(for: self).urls(forResourcesWithExtension: withExtension, subdirectory: subdirectory) ?? []
    }
    
    private static func registerFont(from url: URL) -> Bool {
        return CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
    
}
