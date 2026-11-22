import Foundation
import Combine

// MARK: - SettingsViewModel

final class SettingsViewModel: ObservableObject {
    
    // MARK: - Data
    
    private(set) var menuSections: [MenuSection] = []
    
    private let cacheService: CodableCacheServiceType
    
    // MARK: - Init
                
    init(cacheService: CodableCacheServiceType) {
        self.cacheService = cacheService
        
        setupSections()
    }
}

// MARK: - Setup sections

private extension SettingsViewModel {
    
    func setupSections() {
        let firstSection = MenuSection(
            type: .media,
            items: [.wishlist, .download]
        )
        
        let secondSection = MenuSection(
            type: .preferences,
            items: [.theme, .language]
        )
        
        let thirdSection = MenuSection(
            type: .account,
            items: [.logout, .privacy, .version("1.2.54b")]
        )
        
        menuSections = [firstSection, secondSection, thirdSection]
    }
    
}
