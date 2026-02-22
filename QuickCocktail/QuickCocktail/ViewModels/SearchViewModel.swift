import Foundation
import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var allIngredients: [IngredientItem] = []
    @Published var filteredIngredients: [IngredientItem] = []
    @Published var selectedIngredients: [SelectedIngredient] = []
    @Published var searchResults: [CocktailMatchResult] = []
    @Published var isLoadingIngredients = false
    @Published var isSearching = false
    @Published var errorMessage: String?
    
    private let apiService = CocktailAPIService.shared
    
    var hasSelectedIngredients: Bool {
        !selectedIngredients.isEmpty
    }
    
    var perfectMatches: [CocktailMatchResult] {
        searchResults.filter { $0.isPerfectMatch }
    }
    
    var partialMatches: [CocktailMatchResult] {
        searchResults.filter { !$0.isPerfectMatch }
    }
    
    init() {
        Task {
            await loadIngredients()
        }
    }
    
    func loadIngredients() async {
        isLoadingIngredients = true
        errorMessage = nil
        
        do {
            var apiIngredients = try await apiService.getAllIngredients()
            
            // API'den gelmeyen popüler malzemeleri ekle
            let missingIngredients = Self.popularIngredients.filter { popular in
                !apiIngredients.contains { $0.name.lowercased() == popular.lowercased() }
            }
            
            for ingredient in missingIngredients {
                apiIngredients.append(IngredientItem(strIngredient1: ingredient))
            }
            
            // Alfabetik sırala
            apiIngredients.sort { $0.name.lowercased() < $1.name.lowercased() }
            allIngredients = apiIngredients
            filteredIngredients = allIngredients
        } catch {
            errorMessage = "Malzemeler yüklenirken bir hata oluştu. Lütfen internet bağlantınızı kontrol edin."
        }
        
        isLoadingIngredients = false
    }
    
    // API'den gelmeyen popüler malzemeler
    static let popularIngredients: [String] = [
        // Spirits
        "Tequila", "Mezcal", "Bourbon", "Scotch", "Rye whiskey", "Irish whiskey",
        "White rum", "Dark rum", "Spiced rum", "Coconut rum",
        "Vodka", "Gin", "Brandy", "Cognac",
        
        // Liqueurs
        "Triple sec", "Cointreau", "Grand Marnier", "Blue Curacao",
        "Kahlua", "Baileys", "Amaretto", "Frangelico",
        "Campari", "Aperol", "Midori", "Chambord",
        "Drambuie", "Galliano", "Chartreuse", "Benedictine",
        "Maraschino liqueur", "St-Germain", "Peach schnapps",
        
        // Mixers
        "Tonic water", "Soda water", "Club soda", "Ginger ale", "Ginger beer",
        "Cola", "Lemon-lime soda", "Red Bull",
        
        // Juices
        "Orange juice", "Lemon juice", "Lime juice", "Grapefruit juice",
        "Pineapple juice", "Cranberry juice", "Apple juice", "Tomato juice",
        "Passion fruit juice", "Pomegranate juice",
        
        // Fruits
        "Lime", "Lemon", "Orange", "Grapefruit", "Pineapple",
        "Strawberry", "Raspberry", "Blueberry", "Blackberry",
        "Cherry", "Maraschino cherry", "Apple", "Banana", "Mango", "Peach",
        "Watermelon", "Coconut", "Passion fruit", "Kiwi", "Olive",
        
        // Herbs & Spices
        "Mint", "Fresh mint", "Basil", "Rosemary", "Thyme",
        "Cinnamon", "Nutmeg", "Ginger", "Vanilla",
        "Pepper", "Cayenne pepper", "Jalapeño", "Cucumber", "Celery",
        
        // Sweeteners
        "Simple syrup", "Sugar syrup", "Sugar", "Brown sugar", "Powdered sugar",
        "Honey", "Agave syrup", "Maple syrup", "Grenadine",
        "Orgeat syrup", "Vanilla syrup", "Caramel syrup",
        
        // Bitters
        "Angostura bitters", "Orange bitters", "Peychaud's bitters",
        
        // Dairy & Eggs
        "Cream", "Heavy cream", "Light cream", "Half-and-half",
        "Milk", "Coconut milk", "Coconut cream",
        "Egg", "Egg white", "Egg yolk",
        "Whipped cream",
        
        // Wine & Champagne
        "Champagne", "Prosecco", "Sparkling wine",
        "Red wine", "White wine",
        "Dry vermouth", "Sweet vermouth",
        "Port", "Sherry",
        
        // Other
        "Ice", "Crushed ice", "Salt", "Coffee", "Espresso",
        "Tea", "Hot water", "Water",
        "Tabasco", "Worcestershire sauce",
        "Chocolate", "Cocoa powder"
    ]
    
    func filterIngredients() {
        if searchText.isEmpty {
            filteredIngredients = allIngredients
        } else {
            filteredIngredients = TranslationService.searchIngredients(query: searchText, in: allIngredients)
        }
    }
    
    func selectIngredient(_ ingredient: IngredientItem) {
        let selected = SelectedIngredient(from: ingredient)
        if !selectedIngredients.contains(where: { $0.id == selected.id }) {
            selectedIngredients.append(selected)
        }
        searchText = ""
        filterIngredients()
    }
    
    func removeIngredient(_ ingredient: SelectedIngredient) {
        selectedIngredients.removeAll { $0.id == ingredient.id }
    }
    
    func clearSelection() {
        selectedIngredients.removeAll()
        searchResults.removeAll()
    }
    
    func searchCocktails() async {
        guard hasSelectedIngredients else { return }
        
        isSearching = true
        errorMessage = nil
        
        do {
            let ingredientNames = selectedIngredients.map { $0.name }
            searchResults = try await apiService.filterByMultipleIngredientsWithMatchInfo(ingredientNames)
        } catch let apiError as APIError {
            errorMessage = apiError.localizedDescription
            searchResults = []
        } catch {
            errorMessage = "Kokteyller aranırken bir hata oluştu. Lütfen tekrar deneyin."
            searchResults = []
        }
        
        isSearching = false
    }
}
