import Foundation
import SwiftData

@Model
final class CocktailHistory {
    var cocktailId: String
    var name: String
    var thumbnailURL: String?
    var category: String
    var isAlcoholic: Bool
    var dateViewed: Date
    
    init(
        cocktailId: String,
        name: String,
        thumbnailURL: String? = nil,
        category: String = "",
        isAlcoholic: Bool = true,
        dateViewed: Date = Date()
    ) {
        self.cocktailId = cocktailId
        self.name = name
        self.thumbnailURL = thumbnailURL
        self.category = category
        self.isAlcoholic = isAlcoholic
        self.dateViewed = dateViewed
    }
    
    convenience init(from cocktail: Cocktail) {
        self.init(
            cocktailId: cocktail.id,
            name: cocktail.name,
            thumbnailURL: cocktail.strDrinkThumb,
            category: cocktail.category,
            isAlcoholic: cocktail.isAlcoholic
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
