import SwiftUI

@main
struct EntryApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentApp().environmentObject(themeManager)
        }
    }
    
}

struct ContentApp: View {
    var body: some View {
        TabView {
            SearchResultsUi()
            .badge(2)
            .tabItem { Label("tab.item.home", systemImage: "person.circle.fill") }
            
            Text("2")
            .tabItem { Label("Home", systemImage: "person.circle.fill") }
            
            Text("3")
            .tabItem { Label("tab.item.favorites", systemImage: "bookmark.fill") }
            
            SearchResultsUi()
            .tabItem {
                Label("Профиль", systemImage: "person.circle.fill")
            }
        }
        .accentColor(.label.secondary)
    }
}

#Preview {
    ContentApp()
}
