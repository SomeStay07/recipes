import Foundation

struct Recipe: Decodable, Equatable, Identifiable {
    let id: Int
    let title: String
    let image: URL?
    let imageType: String?
}

struct RecipeSearchResponse: Decodable, Equatable {
    let results: [Recipe]
    let totalResults: Int
}
