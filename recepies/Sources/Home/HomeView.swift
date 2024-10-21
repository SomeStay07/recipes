import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                // Изменяем цвет фона для конфликта
                Color.blue.opacity(0.3).ignoresSafeArea()
                
                // Изменяем текст для конфликта
                Text("Welcome")
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 10) { // Изменяем spacing для конфликта
                        toolbarImage(name: "globe") // Изменяем иконку для конфликта
                        toolbarTitle
                        toolbarImage(name: "chevron.up") // Изменяем иконку для конфликта
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    // Меняем размер круга для конфликта
                    Circle().frame(width: 50, height: 50)
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
        .aspectRatio(contentMode: .fill) // Изменяем contentMode для конфликта
        .frame(width: 18, height: 18) // Меняем размер для конфликта
        .foregroundStyle(.primary) // Меняем стиль для конфликта
        .padding(.horizontal, 4) // Меняем отступы для конфликта
    }
    
}

// MARK: Toolbar title

private extension HomeView {
    
    var toolbarTitle: some View {
        // Изменяем текст для конфликта
        Text("Alex, New York")
        .font(.headline) // Меняем шрифт для конфликта
        .foregroundStyle(.secondary) // Меняем цвет для конфликта
        .border(Color.red) // Меняем цвет границы для конфликта
    }
    
}

#Preview {
    HomeView()
}
