import SwiftUI

struct SettingsView: View {
    
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
    }
}

// MARK: - Header

private extension SettingsView {
    
    var header: some View {
        VStack(spacing: 0) {
            Image(systemName: "apple.logo")
            .resizable()
            .scaledToFit()
            .frame(width: 88, height: 88)
            
            VStack(spacing: 12) {
                Text("Jose Phonie")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color(.label))
                
                Text("JosePhonie123@gmail.com")
                .font(.callout)
                .fontWeight(.thin)
                .multilineTextAlignment(.center)
            }
            .padding(.top, 15)
            .padding(.horizontal, 12)
            .padding(.bottom, 32)
        }
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
    
    func menuSection(title: String) -> some View {
        Text(title)
        .font(.title2)
        .fontWeight(.semibold)
        .foregroundColor(.black)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color.gray, in: RoundedRectangle(cornerRadius: 16.0))
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
                case .version(let name): getVersionCell(
                    showDivider: showDivider,
                    version: name
                )
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
                        setupCell(title: "Wishlist")
                        
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
                        setupCell(title: "Download")
                        
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
                setupCell(title: "Dark mode")
                
                Spacer()
                
                Toggle(isOn: Binding<Bool>(
                    get: { viewModel.themeTypes == .dark },
                    set: { newValue in
                        viewModel.themeTypes = newValue ? .dark : .light
                    }
                )) {}
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
                        setupCell(title: "Language")
                        
                        Spacer()
                        
                        chevron
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
                        setupCell(title: "Logout")
                        
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
                        setupCell(title: "Privacy")
                        
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
        VStack(spacing: showDivider ? 12 : 0) {
            HStack {
                setupCell(icon: "doc.append.fill.rtl")
                setupCell(title: "Version: \(version)")
                
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
        .foregroundColor(.gray)
    }
    
}

// MARK: - Setup cell title

private extension SettingsView {
    
    func setupCell(title: String) -> some View {
        Text(title)
        .font(.headline)
        .foregroundColor(Color(.label))
        .padding(.leading, 10)
    }
    
}

// MARK: - Setup chevron

private extension SettingsView {
    
    var chevron: some View {
        Image(systemName: "chevron.right")
        .resizable()
        .scaledToFit()
        .frame(width: 24, height: 24)
        .foregroundColor(.gray)
    }
    
}

#Preview {
    SettingsView(
        viewModel: SettingsViewModel(
            cacheService: CacheServiceImpl()
        )
    )
}
