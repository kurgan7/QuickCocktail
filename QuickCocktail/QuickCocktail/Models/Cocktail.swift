import Foundation

struct CocktailResponse: Codable {
    let drinks: [Cocktail]?
}

struct Cocktail: Codable, Identifiable, Hashable {
    let idDrink: String
    let strDrink: String
    let strDrinkAlternate: String?
    let strTags: String?
    let strVideo: String?
    let strCategory: String?
    let strIBA: String?
    let strAlcoholic: String?
    let strGlass: String?
    let strInstructions: String?
    let strInstructionsTR: String?
    let strDrinkThumb: String?
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?
    let dateModified: String?
    
    var id: String { idDrink }
    
    var name: String { strDrink }
    
    var thumbnailURL: URL? {
        guard let urlString = strDrinkThumb else { return nil }
        return URL(string: urlString)
    }
    
    var previewThumbnailURL: URL? {
        guard let urlString = strDrinkThumb else { return nil }
        return URL(string: "\(urlString)/preview")
    }
    
    var instructions: String {
        strInstructionsTR ?? strInstructions ?? "Talimat bulunamadı."
    }
    
    var category: String {
        strCategory ?? "Bilinmiyor"
    }
    
    var glassType: String {
        strGlass ?? "Bilinmiyor"
    }
    
    var isAlcoholic: Bool {
        strAlcoholic?.lowercased() == "alcoholic"
    }
    
    var alcoholicLabel: String {
        if strAlcoholic?.lowercased() == "alcoholic" {
            return "Alkollü"
        } else if strAlcoholic?.lowercased() == "non alcoholic" {
            return "Alkolsüz"
        } else {
            return strAlcoholic ?? "Bilinmiyor"
        }
    }
    
    var ingredientsWithMeasures: [(ingredient: String, measure: String)] {
        var result: [(String, String)] = []
        
        let ingredients = [strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5,
                          strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10,
                          strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15]
        
        let measures = [strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5,
                       strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10,
                       strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15]
        
        for (index, ingredient) in ingredients.enumerated() {
            if let ing = ingredient, !ing.trimmingCharacters(in: .whitespaces).isEmpty {
                let measure = measures[index]?.trimmingCharacters(in: .whitespaces) ?? ""
                result.append((ing, measure))
            }
        }
        
        return result
    }
    
    var ingredientCount: Int {
        ingredientsWithMeasures.count
    }
    
    var difficultyLevel: String {
        switch ingredientCount {
        case 1...3: return "Kolay"
        case 4...6: return "Orta"
        default: return "Zor"
        }
    }
    
    var difficultyColor: String {
        switch ingredientCount {
        case 1...3: return "green"
        case 4...6: return "orange"
        default: return "red"
        }
    }
}

struct CocktailSummary: Codable, Identifiable, Hashable {
    let strDrink: String
    let strDrinkThumb: String?
    let idDrink: String
    
    var id: String { idDrink }
    
    var name: String { strDrink }
    
    var thumbnailURL: URL? {
        guard let urlString = strDrinkThumb else { return nil }
        return URL(string: urlString)
    }
    
    var previewThumbnailURL: URL? {
        guard let urlString = strDrinkThumb else { return nil }
        return URL(string: "\(urlString)/preview")
    }
}

struct CocktailSummaryResponse: Codable {
    let drinks: [CocktailSummary]?
}

struct CocktailMatchResult: Identifiable, Hashable {
    let cocktail: CocktailSummary
    let matchCount: Int
    let totalIngredients: Int
    let matchedIngredients: [String]
    
    var id: String { cocktail.id }
    
    var matchPercentage: Double {
        guard totalIngredients > 0 else { return 0 }
        return Double(matchCount) / Double(totalIngredients) * 100
    }
    
    var matchLabel: String {
        "\(matchCount)/\(totalIngredients) malzeme"
    }
    
    var isPerfectMatch: Bool {
        matchCount == totalIngredients
    }
}
