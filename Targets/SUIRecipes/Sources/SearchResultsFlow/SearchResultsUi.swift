import SwiftUI

struct SearchResultsUi: View {
    
    private let historyData: [String] = [
        "My search history",
        "My favourite recipes",
        "My favourite recipes",
        "My favourite recipes",
        "My favourite recipes",
        "Easy Mexican Casserole",
        "My favourite recipes",
        "My favourite recipes",
        "My favourite recipes",
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            header
            search
        }
    }
    
    var search: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(historyData.indices, id: \.self) { index in
                    cell(
                        title: historyData[index],
                        isDividerExist: historyData.count - 1 != index
                    )
                }
            }
        }
        .padding(.top, 6)
        .background(Color.white)
        .cornerRadius(24, corners: [.topLeft, .topRight])
        .offset(x: 0, y: -36)
    }
    
    func cell(
        title: String,
        isDividerExist: Bool
    ) -> some View {
        VStack {
            HStack {
                Text(title)
                .font(.description.customWeight(.heavy))
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 11)
            }
            .padding(.vertical, 17)
            
            Divider()
            .frame(height: 0.5)
            .opacity(isDividerExist ? 1 : 0)
        }
        .padding(.horizontal, 35)
        .foregroundColor(.gray)
    }
    
}

// MARK: - Header

private extension SearchResultsUi {
    
    var header: some View {
        ZStack(alignment: .top) {
            headerImage
            
            HStack(spacing: 0) {
                backButton
                Spacer()
                helpTooltip
            }
            .padding(.horizontal, 55)
        }
        .background(Color.green)
    }
    
    var headerImage: some View {
        Image("search-result-background")
        .resizable()
        .scaledToFill()
        .ignoresSafeArea()
    }
    
}

// MARK: - Toolbar

private extension SearchResultsUi {
    
    var backButton: some View {
        Button(
            action: { print("back button") },
            label: { backButtonImage }
        )
        .frame(width: 40, height: 40)
        .background(Color.background.ghost, in: Circle())
    }
    
    var backButtonImage: some View {
        Image(systemName: "arrow.backward")
        .resizable()
        .scaledToFit()
        .frame(width: 20, height: 14)
        .foregroundColor(.white)
        .offset(x: 2)
    }
    
    var helpTooltip: some View {
        HStack(spacing: 10) {
            helpTooltipTitle
            helpTooltipImage
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(
            Color.white.opacity(0.7),
            in: RoundedRectangle(cornerRadius: 12)
        )
    }
    
    var helpTooltipTitle: some View {
        Text("Swipe to search by ingredients")
        .font(.callout)
        .foregroundColor(.black)
        .fontWeight(.bold)
    }
    
    var helpTooltipImage: some View {
        Image(systemName: "chevron.left")
        .resizable()
        .scaledToFit()
        .frame(width: 10, height: 8)
        .foregroundColor(.black)
        .rotationEffect(.degrees(180))
    }
    
}

#Preview {
    SearchResultsUi()
}
