import Foundation
import Combine

// MARK: - SettingsViewModel

final class SettingsViewModel: ObservableObject {
    
    // MARK: - Data
    
    @Published private(set) var menuSections: [MenuSection] = []
    
    @Published var themeTypes: ThemeTypes
    
    private let cacheService: CodableCacheServiceType
    
    private var store = Set<AnyCancellable>()
    
    // MARK: - Init
                
    init(cacheService: CodableCacheServiceType) {
        self.cacheService = cacheService
        
        themeTypes = cacheService.read(key: ThemeManager.name) ?? .unspecified
        
        setupSections()
        obtainTheme()
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

// MARK: - Obtain theme

private extension SettingsViewModel {
    
    func obtainTheme() {
        $themeTypes
            .receive(on: DispatchQueue.main)
            .sink { theme in
                ThemeManager.shared.currentThemeType = theme
                
                self.cacheService.write(theme, key: ThemeManager.name)
            }
            .store(in: &store)
    }
    
}
