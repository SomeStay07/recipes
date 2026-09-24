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
                .autocorrectionDisabled()
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
            historyList
        case .loading:
            loadingView
        case .loaded(let recipes):
            recipesList(recipes)
        case .empty:
            emptyView
        case .failed(let error):
            errorView(error)
        }
    }
    
    // MARK: - History
    
    private var historyList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(store.state.history.indices, id: \.self) { index in
                    cell(
                        title: store.state.history[index],
                        imageUrl: nil,
                        isDividerExist: store.state.history.count - 1 != index,
                        action: {
                            queryInput = store.state.history[index]
                            store.send(.selectHistory(index))
                        }
                    )
                }
            }
            .padding(.top, 4)
        }
    }
    
    // MARK: - Results
    
    private func recipesList(_ recipes: [Recipe]) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(Array(recipes.enumerated()), id: \.element.id) { index, recipe in
                    cell(
                        title: recipe.title,
                        imageUrl: recipe.image,
                        isDividerExist: recipes.count - 1 != index,
                        action: {}
                    )
                }
            }
            .padding(.top, 4)
        }
    }
    
    // MARK: - Loading
    
    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("search.loading.title")
                .font(.caption)
                .foregroundColor(.label.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 40)
    }
    
    // MARK: - Empty
    
    private var emptyView: some View {
        message(
            systemImage: "magnifyingglass",
            title: "search.empty.title",
            subtitle: "search.empty.subtitle"
        )
    }
    
    // MARK: - Error
    
    private func errorView(_ error: SearchError) -> some View {
        VStack(spacing: 16) {
            message(
                systemImage: "exclamationmark.triangle",
                title: LocalizedStringKey(error.titleKey),
                subtitle: LocalizedStringKey(error.subtitleKey)
            )
            
            if error.isRetryable {
                Button("search.error.retry") {
                    store.send(.retry)
                }
                .font(.headline)
                .foregroundColor(.label.primary)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.background.ghost, in: RoundedRectangle(cornerRadius: 12))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func message(
        systemImage: String,
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey
    ) -> some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.largeTitle)
                .foregroundColor(.label.secondary)
            Text(title)
                .font(.headline)
                .foregroundColor(.label.primary)
            Text(subtitle)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.label.secondary)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    // MARK: - Cell
    
    private func cell(
        title: String,
        imageUrl: URL?,
        isDividerExist: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack {
                HStack(spacing: 12) {
                    if let imageUrl {
                        thumbnail(imageUrl)
                    }
                    
                    Text(title)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
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
    
    private func thumbnail(_ url: URL) -> some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Color.background.ghost
        }
        .frame(width: 56, height: 56)
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
