import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var randomCocktail: Cocktail?
    @Published var popularCocktails: [Cocktail] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = CocktailAPIService.shared
    
    func loadInitialData() async {
        isLoading = true
        errorMessage = nil
        
        async let randomTask = loadRandomCocktail()
        async let popularTask = loadPopularCocktails()
        
        await randomTask
        await popularTask
        
        isLoading = false
    }
    
    func loadRandomCocktail() async {
        do {
            randomCocktail = try await apiService.getRandomCocktail()
        } catch let apiError as APIError {
            errorMessage = apiError.localizedDescription
        } catch {
            errorMessage = "Kokteyller yüklenirken bir hata oluştu. Lütfen internet bağlantınızı kontrol edin."
        }
    }
    
    func loadPopularCocktails() async {
        do {
            popularCocktails = try await apiService.getPopularCocktails()
        } catch let apiError as APIError {
            errorMessage = apiError.localizedDescription
        } catch {
            errorMessage = "Popüler kokteyller yüklenirken bir hata oluştu."
        }
    }
    
    func refreshRandomCocktail() async {
        await loadRandomCocktail()
    }
}
