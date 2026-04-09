import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var languageManager: LanguageManager
    @ObservedObject private var viewModel: SettingsViewModel
    
    // MARK: - Init
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            header
            menu
        }
        .background(
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color.background.primary,
                        Color.background.secondary
                    ]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

// MARK: - Header

private extension SettingsView {
    
    var header: some View {
        VStack {
            Image("settings-background")
            .resizable()
            .scaledToFit()
            .cornerRadius(16, corners: .allCorners)
            .shadow(radius: 8)
            .foregroundStyle(Color.label.secondary)
            
            Text("settings.profile.name")
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(Color.element.primary)
            .padding(.vertical, 15)
        }
        .padding(16)
    }
    
}

// MARK: - Menu

private extension SettingsView {
    
    var menu: some View {
        ScrollView {
            VStack(spacing: 0) {
                LazyVStack(spacing: 21) {
                    ForEach(0..<viewModel.menuSections.count, id: \.self) { index in
                        menuSection(title: viewModel.menuSections[index].type.title)
                        menuSectionItems(section: viewModel.menuSections[index])
                    }
                }
            }
            .padding(.bottom, 32)
        }
    }
    
    func menuSection(title: LocalizedStringKey) -> some View {
        Text(title)
        .font(.title2)
        .fontWeight(.semibold)
        .foregroundStyle(Color.label.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color.background.ghost, in: RoundedRectangle(cornerRadius: 16.0))
        .padding(.leading, 16)
        .padding(.trailing, 31)
    }
    
}

// MARK: - Menu section items

private extension SettingsView {
    
    func menuSectionItems(section: MenuSection) -> some View {
        LazyVStack(spacing: 24) {
            ForEach(0..<section.items.count, id: \.self) { index in
                let menuItem = section.items[index]
                let showDivider = (index != (section.items.count - 1))
                
                switch menuItem {
                case .wishlist: getWishlistCell(showDivider: showDivider)
                case .download: getDownloadCell(showDivider: showDivider)
                case .theme: getThemeCell(showDivider: showDivider)
                case .language: getLanguageCell(showDivider: showDivider)
                case .logout: getLogoutCell(showDivider: showDivider)
                case .privacy: getPrivacyCell(showDivider: showDivider)
                case .version(let name): getVersionCell(showDivider: showDivider, version: name)
                }
            }
        }
        .padding(.leading, 26)
        .padding(.trailing, 31)
    }
    
}

// MARK: - Wishlist cell

private extension SettingsView {
    
    func getWishlistCell(showDivider: Bool) -> some View {
        Button(
            action: { print("Execution wishlist") },
            label: {
                VStack(spacing: showDivider ? 12 : 0) {
                    HStack {
                        setupCell(icon: "heart")
                        setupCell(title: "settings.menu.wishlist")
                        
                        Spacer()
                        
                        chevron
                    }
                    
                    Divider().opacity(showDivider ? 1 : 0)
                }
            }
        )
    }
    
}

// MARK: - Download cell

private extension SettingsView {
    
    func getDownloadCell(showDivider: Bool) -> some View {
        Button(
            action: { print("Execution download") },
            label: {
                VStack(spacing: showDivider ? 12 : 0) {
                    HStack {
                        setupCell(icon: "icloud.and.arrow.down")
                        setupCell(title: "settings.menu.download")
                        
                        Spacer()
                        
                        chevron
                    }
                    
                    Divider().opacity(showDivider ? 1 : 0)
                }
            }
        )
    }
    
}

// MARK: - Theme cell

private extension SettingsView {
    
    func getThemeCell(showDivider: Bool) -> some View {
        VStack(spacing: showDivider ? 12 : 0) {
            HStack {
                setupCell(icon: "moon")
                setupCell(title: "settings.menu.theme")

                Spacer()

                Picker("settings.menu.theme", selection: $themeManager.currentThemeType) {
                    ForEach(ThemeTypes.allCases, id: \.id) { theme in
                        Text(theme.displayName).tag(theme)
                    }
                }
                .pickerStyle(.menu)
                .tint(Color.label.primary)
            }
            
            Divider().opacity(showDivider ? 1 : 0)
        }
    }
    
}

// MARK: - Language cell

private extension SettingsView {
    
    func getLanguageCell(showDivider: Bool) -> some View {
        Button(
            action: { print("Execution language") },
            label: {
                VStack(spacing: showDivider ? 12 : 0) {
                    HStack {
                        setupCell(icon: "globe.badge.chevron.backward")
                        setupCell(title: "settings.menu.language")

                        Spacer()

                        Picker("settings.menu.language", selection: $languageManager.currentLanguage) {
                            ForEach(LanguageType.allCases, id: \.id) { lang in
                                Text(lang.displayName).tag(lang)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(Color.label.primary)
                    }
                    
                    Divider().opacity(showDivider ? 1 : 0)
                }
            }
        )
    }
}

// MARK: - Logout cell

private extension SettingsView {
    
    func getLogoutCell(showDivider: Bool) -> some View {
        Button(
            action: { print("Execution logout") },
            label: {
                VStack(spacing: showDivider ? 12 : 0) {
                    HStack {
                        setupCell(icon: "rectangle.portrait.and.arrow.forward")
                        setupCell(title: "settings.menu.logout")
                        
                        Spacer()
                        
                        chevron
                    }
                    
                    Divider().opacity(showDivider ? 1 : 0)
                }
            }
        )
    }
    
}

// MARK: - Privacy cell

private extension SettingsView {
    
    func getPrivacyCell(showDivider: Bool) -> some View {
        Button(
            action: { print("Execution privacy") },
            label: {
                VStack(spacing: showDivider ? 12 : 0) {
                    HStack {
                        setupCell(icon: "person.badge.shield.checkmark.fill")
                        setupCell(title: "settings.menu.privacy")
                        
                        Spacer()
                        
                        chevron
                    }
                    
                    Divider().opacity(showDivider ? 1 : 0)
                }
            }
        )
    }
    
}

// MARK: - Version cell

private extension SettingsView {
    
    func getVersionCell(showDivider: Bool, version: String) -> some View {
        let title: LocalizedStringKey = "settings.menu.version \(version)"
        return VStack(spacing: showDivider ? 12 : 0) {
            HStack {
                setupCell(icon: "doc.append.fill.rtl")
                setupCell(title: title)
                
                Spacer()
                
                chevron
            }
            
            Divider().opacity(showDivider ? 1 : 0)
        }
    }
    
}

// MARK: - Setup cell icon

private extension SettingsView {
    
    func setupCell(icon: String) -> some View {
        Image(systemName: icon)
        .resizable()
        .scaledToFit()
        .frame(width: 24, height: 24)
        .foregroundStyle(Color.label.primary)
    }
    
}

// MARK: - Setup cell title

private extension SettingsView {
    
    func setupCell(title: LocalizedStringKey) -> some View {
        Text(title)
        .font(.headline)
        .foregroundStyle(Color.label.primary)
        .padding(.leading, 10)
    }
    
}

// MARK: - Setup chevron

private extension SettingsView {
    
    var chevron: some View {
        setupCell(icon: "chevron.right")
    }
    
}

#Preview {
    SettingsView(
        viewModel: SettingsViewModel(
            cacheService: CacheServiceImpl()
        )
    )
}
