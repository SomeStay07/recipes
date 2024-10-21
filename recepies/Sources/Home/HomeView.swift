import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                // Изменяем цвет фона на другой для конфликта
                Color.red.opacity(0.1).ignoresSafeArea()
                
                // Изменяем текст для конфликта
                Text("Hello, Swift!")
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 20) { // Изменяем spacing для конфликта
                        toolbarImage(name: "star.fill") // Изменяем иконку для конфликта
                        toolbarTitle
                        toolbarImage(name: "arrow.down") // Изменяем иконку для конфликта
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    // Меняем размер круга для конфликта
                    Circle().frame(width: 30, height: 30)
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
        .aspectRatio(contentMode: .fit) // Изменяем contentMode для конфликта
        .frame(width: 25, height: 25) // Меняем размер для конфликта
        .foregroundStyle(.secondary) // Меняем стиль для конфликта
        .padding(.vertical, 6) // Меняем отступы для конфликта
    }
    
}

// MARK: Toolbar title

private extension HomeView {
    
    var toolbarTitle: some View {
        // Изменяем текст для конфликта
        Text("John, London")
        .font(.title) // Меняем шрифт для конфликта
        .foregroundStyle(.primary) // Меняем цвет для конфликта
        .border(Color.green) // Меняем цвет границы для конфликта
    }
    
}

#Preview {
    HomeView()
}
