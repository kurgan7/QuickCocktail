import Foundation
import SwiftData

@Model
final class ShoppingListItem {
    @Attribute(.unique) var ingredientName: String
    var displayName: String
    var isChecked: Bool
    var dateAdded: Date
    var fromCocktail: String?
    
    init(
        ingredientName: String,
        displayName: String? = nil,
        isChecked: Bool = false,
        dateAdded: Date = Date(),
        fromCocktail: String? = nil
    ) {
        self.ingredientName = ingredientName
        self.displayName = displayName ?? ingredientName
        self.isChecked = isChecked
        self.dateAdded = dateAdded
        self.fromCocktail = fromCocktail
    }
    
    var hasMarketLinks: Bool {
        IngredientMarketLinks.hasLinks(for: ingredientName)
    }
    
    var marketLinks: [IngredientMarketLink] {
        IngredientMarketLinks.getLinks(for: ingredientName)
    }
}

class ShoppingListManager: ObservableObject {
    @Published var items: [ShoppingListItem] = []
    
    static let shared = ShoppingListManager()
    
    private init() {}
    
    func addItem(_ ingredientName: String, fromCocktail: String? = nil, modelContext: ModelContext) {
        let targetName = ingredientName
        let descriptor = FetchDescriptor<ShoppingListItem>(
            predicate: #Predicate<ShoppingListItem> { item in
                item.ingredientName == targetName
            }
        )
        
        if let existing = try? modelContext.fetch(descriptor), !existing.isEmpty {
            return
        }
        
        let item = ShoppingListItem(
            ingredientName: ingredientName,
            fromCocktail: fromCocktail
        )
        modelContext.insert(item)
        try? modelContext.save()
    }
    
    func removeItem(_ item: ShoppingListItem, modelContext: ModelContext) {
        modelContext.delete(item)
        try? modelContext.save()
    }
    
    func toggleItem(_ item: ShoppingListItem, modelContext: ModelContext) {
        item.isChecked.toggle()
        try? modelContext.save()
    }
    
    func clearCheckedItems(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<ShoppingListItem>(
            predicate: #Predicate<ShoppingListItem> { item in
                item.isChecked == true
            }
        )
        
        if let checkedItems = try? modelContext.fetch(descriptor) {
            for item in checkedItems {
                modelContext.delete(item)
            }
            try? modelContext.save()
        }
    }
    
    func clearAllItems(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<ShoppingListItem>()
        
        if let allItems = try? modelContext.fetch(descriptor) {
            for item in allItems {
                modelContext.delete(item)
            }
            try? modelContext.save()
        }
    }
}
