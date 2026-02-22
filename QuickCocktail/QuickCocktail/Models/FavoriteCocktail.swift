import Foundation
import SwiftData

@Model
final class FavoriteCocktail {
    @Attribute(.unique) var cocktailId: String
    var name: String
    var thumbnailURL: String?
    var category: String
    var isAlcoholic: Bool
    var ingredientCount: Int
    var dateAdded: Date
    
    init(
        cocktailId: String,
        name: String,
        thumbnailURL: String? = nil,
        category: String = "",
        isAlcoholic: Bool = true,
        ingredientCount: Int = 0,
        dateAdded: Date = Date()
    ) {
        self.cocktailId = cocktailId
        self.name = name
        self.thumbnailURL = thumbnailURL
        self.category = category
        self.isAlcoholic = isAlcoholic
        self.ingredientCount = ingredientCount
        self.dateAdded = dateAdded
    }
    
    convenience init(from cocktail: Cocktail) {
        self.init(
            cocktailId: cocktail.id,
            name: cocktail.name,
            thumbnailURL: cocktail.strDrinkThumb,
            category: cocktail.category,
            isAlcoholic: cocktail.isAlcoholic,
            ingredientCount: cocktail.ingredientCount
        )
    }
    
    var imageURL: URL? {
        guard let urlString = thumbnailURL else { return nil }
        return URL(string: urlString)
    }
    
    var previewImageURL: URL? {
        guard let urlString = thumbnailURL else { return nil }
        return URL(string: "\(urlString)/preview")
    }
}
