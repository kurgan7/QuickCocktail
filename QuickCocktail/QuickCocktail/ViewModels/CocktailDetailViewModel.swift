import Foundation
import SwiftUI
import SwiftData

@MainActor
class CocktailDetailViewModel: ObservableObject {
    @Published var cocktail: Cocktail?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isFavorite = false
    
    private let apiService = CocktailAPIService.shared
    
    func loadCocktail(id: String, modelContext: ModelContext) async {
        isLoading = true
        errorMessage = nil
        
        do {
            cocktail = try await apiService.getCocktailById(id)
            
            if let cocktail = cocktail {
                addToHistory(cocktail, modelContext: modelContext)
                checkIfFavorite(cocktailId: cocktail.id, modelContext: modelContext)
            }
        } catch let apiError as APIError {
            errorMessage = apiError.localizedDescription
        } catch {
            errorMessage = "Kokteyl detayları yüklenirken bir hata oluştu. Lütfen tekrar deneyin."
        }
        
        isLoading = false
    }
    
    func toggleFavorite(modelContext: ModelContext) {
        guard let cocktail = cocktail else { return }
        
        if isFavorite {
            removeFromFavorites(cocktailId: cocktail.id, modelContext: modelContext)
        } else {
            addToFavorites(cocktail, modelContext: modelContext)
        }
        
        isFavorite.toggle()
    }
    
    private func addToFavorites(_ cocktail: Cocktail, modelContext: ModelContext) {
        let favorite = FavoriteCocktail(from: cocktail)
        modelContext.insert(favorite)
        try? modelContext.save()
    }
    
    private func removeFromFavorites(cocktailId: String, modelContext: ModelContext) {
        let targetId = cocktailId
        let descriptor = FetchDescriptor<FavoriteCocktail>(
            predicate: #Predicate<FavoriteCocktail> { fav in
                fav.cocktailId == targetId
            }
        )
        
        if let favorites = try? modelContext.fetch(descriptor), let favorite = favorites.first {
            modelContext.delete(favorite)
            try? modelContext.save()
        }
    }
    
    private func checkIfFavorite(cocktailId: String, modelContext: ModelContext) {
        let targetId = cocktailId
        let descriptor = FetchDescriptor<FavoriteCocktail>(
            predicate: #Predicate<FavoriteCocktail> { fav in
                fav.cocktailId == targetId
            }
        )
        
        isFavorite = (try? modelContext.fetchCount(descriptor)) ?? 0 > 0
    }
    
    private func addToHistory(_ cocktail: Cocktail, modelContext: ModelContext) {
        let targetId = cocktail.id
        let descriptor = FetchDescriptor<CocktailHistory>(
            predicate: #Predicate<CocktailHistory> { history in
                history.cocktailId == targetId
            }
        )
        
        if let existing = try? modelContext.fetch(descriptor), let history = existing.first {
            history.dateViewed = Date()
        } else {
            let history = CocktailHistory(from: cocktail)
            modelContext.insert(history)
        }
        
        try? modelContext.save()
    }
    
    func getMarketLinks(for ingredientName: String) -> [IngredientMarketLink] {
        return IngredientMarketLinks.getLinks(for: ingredientName)
    }
}
