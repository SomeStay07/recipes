import SwiftUI

@main
struct EntryApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentApp()
        }
    }
    
}

struct ContentApp: View {
    var body: some View {
        TabView {
            Text("1")
            .badge(2)
            .tabItem { Label("tab.item.home", systemImage: "person.circle.fill") }
            
            Text("2")
            .tabItem { Label("Home", systemImage: "person.circle.fill") }
            
            Text("3")
            .tabItem { Label("tab.item.favorites", systemImage: "bookmark.fill") }
            
            Text("4")
            .tabItem { Label("Профиль", systemImage: "person.circle.fill") }
        }
        .accentColor(.red)
    }
}
