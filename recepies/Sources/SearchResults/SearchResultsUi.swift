import SwiftUI

// MARK: - SearchResultsUi

struct SearchResultsUi: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var store = SearchStore()
    @State private var queryInput: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            header
            sheet
        }
        .background(Color.background.primary)
    }
    
    // MARK: - Sheet
    
    private var sheet: some View {
        VStack(spacing: 0) {
            searchField
            content
        }
        .background(Color.background.primary)
        .cornerRadius(24, corners: [.topLeft, .topRight])
        .offset(y: -36)
    }
    
    // MARK: - Search field
    
    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.label.secondary)
            
            TextField("search.tooltip.swipe", text: $queryInput)
                .textFieldStyle(.plain)
                .submitLabel(.search)
                .onSubmit {
                    store.send(.submit(queryInput))
                }
            
            if queryInput.isEmpty == false {
                Button {
                    queryInput = ""
                    store.send(.clear)
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.label.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.background.ghost, in: RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 12)
    }
    
    // MARK: - Content
    
    @ViewBuilder
    private var content: some View {
        switch store.state.phase {
        case .idle:
            list(items: store.state.history, isHistory: true)
        case .loaded(let results):
            list(items: results, isHistory: false)
        case .empty:
            emptyView
        }
    }
    
    private func list(items: [String], isHistory: Bool) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { index in
                    cell(
                        title: items[index],
                        isDividerExist: items.count - 1 != index,
                        action: {
                            if isHistory {
                                store.send(.selectHistory(index))
                                queryInput = items[index]
                            }
                        }
                    )
                }
            }
            .padding(.top, 4)
        }
    }
    
    private var emptyView: some View {
        VStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .foregroundColor(.label.secondary)
            Text("search.empty.title")
                .font(.headline)
                .foregroundColor(.label.primary)
            Text("search.empty.subtitle")
                .font(.caption)
                .foregroundColor(.label.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 40)
    }
    
    private func cell(
        title: String,
        isDividerExist: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.label.primary)
                    
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
            .foregroundColor(.label.secondary)
        }
        .buttonStyle(.plain)
    }
    
}

// MARK: - Header

private extension SearchResultsUi {
    
    var header: some View {
        ZStack(alignment: .top) {
            headerImage
            
            HStack {
                backButton
                Spacer()
                helpTooltip
            }
            .padding(.horizontal, 16)
        }
    }
    
    var headerImage: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.background.secondary,
                Color.background.primary
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: 180)
        .ignoresSafeArea(edges: .top)
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
            .foregroundColor(.label.primary)
    }
    
    var helpTooltip: some View {
        HStack(spacing: 10) {
            helpTooltipTitle
            helpTooltipImage
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(
            Color.background.primary.opacity(0.7),
            in: RoundedRectangle(cornerRadius: 12)
        )
    }
    
    var helpTooltipTitle: some View {
        Text("search.tooltip.swipe")
            .font(.callout)
            .foregroundColor(.label.primary)
            .fontWeight(.bold)
    }
    
    var helpTooltipImage: some View {
        Image(systemName: "chevron.left")
            .resizable()
            .scaledToFit()
            .frame(width: 10, height: 8)
            .foregroundColor(.label.primary)
            .rotationEffect(.degrees(180))
    }
    
}

#Preview {
    SearchResultsUi()
}

