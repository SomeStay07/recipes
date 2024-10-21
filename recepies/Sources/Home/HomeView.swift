import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.green.opacity(0.2).ignoresSafeArea()
                
                Text("Welcome")
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 14) {
                        toolbarImage(name: "location.viewfinder")
                        toolbarTitle
                        toolbarImage(name: "chevron.down")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Circle().frame(width: 42, height: 42)
                }
            }
        }
    }
    
}

// MARK: - Toolbar image

private extension HomeView {
    
    func toolbarImage(name: String) -> some View {
        Image(systemName: name)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 21, height: 21)
        .foregroundStyle(.secondary)
        .padding(.vertical, 2)
    }
    
}

// MARK: Toolbar title

private extension HomeView {
    
    var toolbarTitle: some View {
        Text("Maxim, Cibulsky")
        .font(.caption)
        .foregroundStyle(.primary)
        .border(Color.blue)
    }
    
}

#Preview {
    HomeView()
}
