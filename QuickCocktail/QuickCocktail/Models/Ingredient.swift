import Foundation

struct IngredientListResponse: Codable {
    let drinks: [IngredientItem]?
}

struct IngredientItem: Codable, Identifiable, Hashable {
    let strIngredient1: String
    
    var id: String { strIngredient1 }
    var name: String { strIngredient1 }
    
    init(strIngredient1: String) {
        self.strIngredient1 = strIngredient1
    }
    
    var thumbnailURL: URL? {
        let encodedName = strIngredient1.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? strIngredient1
        return URL(string: "https://www.thecocktaildb.com/images/ingredients/\(encodedName)-Medium.png")
    }
    
    var smallThumbnailURL: URL? {
        let encodedName = strIngredient1.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? strIngredient1
        return URL(string: "https://www.thecocktaildb.com/images/ingredients/\(encodedName)-Small.png")
    }
}

struct SelectedIngredient: Identifiable, Hashable {
    let id: String
    let name: String
    let turkishName: String
    
    init(from item: IngredientItem) {
        self.id = item.id
        self.name = item.name
        self.turkishName = TranslationService.translateIngredient(item.name)
    }
    
    init(name: String) {
        self.id = name
        self.name = name
        self.turkishName = TranslationService.translateIngredient(name)
    }
    
    var displayName: String {
        turkishName
    }
}

struct IngredientMarketLink: Identifiable {
    let id = UUID()
    let ingredientName: String
    let displayName: String
    let url: URL
    let store: MarketStore
    
    enum MarketStore: String, CaseIterable {
        case trendyol = "Trendyol"
        case hepsiburada = "Hepsiburada"
        case migros = "Migros"
        case getir = "Getir"
        
        var iconName: String {
            switch self {
            case .trendyol: return "cart.fill"
            case .hepsiburada: return "bag.fill"
            case .migros: return "basket.fill"
            case .getir: return "shippingbox.fill"
            }
        }
        
        var color: String {
            switch self {
            case .trendyol: return "orange"
            case .hepsiburada: return "orange"
            case .migros: return "orange"
            case .getir: return "purple"
            }
        }
    }
}

struct IngredientMarketLinks {
    static let links: [String: [IngredientMarketLink]] = [
        "Simple Syrup": [
            IngredientMarketLink(
                ingredientName: "Simple Syrup",
                displayName: "Şeker Şurubu",
                url: URL(string: "https://www.trendyol.com/sr?q=seker%20surubu")!,
                store: .trendyol
            ),
            IngredientMarketLink(
                ingredientName: "Simple Syrup",
                displayName: "Şeker Şurubu",
                url: URL(string: "https://www.hepsiburada.com/ara?q=seker+surubu")!,
                store: .hepsiburada
            )
        ],
        "Sugar Syrup": [
            IngredientMarketLink(
                ingredientName: "Sugar Syrup",
                displayName: "Şeker Şurubu",
                url: URL(string: "https://www.trendyol.com/sr?q=seker%20surubu")!,
                store: .trendyol
            )
        ],
        "Grenadine": [
            IngredientMarketLink(
                ingredientName: "Grenadine",
                displayName: "Grenadine Şurubu",
                url: URL(string: "https://www.trendyol.com/sr?q=grenadine")!,
                store: .trendyol
            ),
            IngredientMarketLink(
                ingredientName: "Grenadine",
                displayName: "Grenadine Şurubu",
                url: URL(string: "https://www.hepsiburada.com/ara?q=grenadine")!,
                store: .hepsiburada
            )
        ],
        "Angostura Bitters": [
            IngredientMarketLink(
                ingredientName: "Angostura Bitters",
                displayName: "Angostura Bitter",
                url: URL(string: "https://www.trendyol.com/sr?q=angostura%20bitter")!,
                store: .trendyol
            ),
            IngredientMarketLink(
                ingredientName: "Angostura Bitters",
                displayName: "Angostura Bitter",
                url: URL(string: "https://www.hepsiburada.com/ara?q=angostura+bitter")!,
                store: .hepsiburada
            )
        ],
        "Bitters": [
            IngredientMarketLink(
                ingredientName: "Bitters",
                displayName: "Bitter",
                url: URL(string: "https://www.trendyol.com/sr?q=cocktail%20bitter")!,
                store: .trendyol
            )
        ],
        "Triple Sec": [
            IngredientMarketLink(
                ingredientName: "Triple Sec",
                displayName: "Triple Sec",
                url: URL(string: "https://www.trendyol.com/sr?q=triple%20sec")!,
                store: .trendyol
            )
        ],
        "Blue Curacao": [
            IngredientMarketLink(
                ingredientName: "Blue Curacao",
                displayName: "Blue Curacao",
                url: URL(string: "https://www.trendyol.com/sr?q=blue%20curacao")!,
                store: .trendyol
            )
        ],
        "Lime Juice": [
            IngredientMarketLink(
                ingredientName: "Lime Juice",
                displayName: "Lime Suyu",
                url: URL(string: "https://www.trendyol.com/sr?q=lime%20suyu")!,
                store: .trendyol
            ),
            IngredientMarketLink(
                ingredientName: "Lime Juice",
                displayName: "Misket Limonu",
                url: URL(string: "https://www.getir.com/ara?q=misket%20limonu")!,
                store: .getir
            )
        ],
        "Lime": [
            IngredientMarketLink(
                ingredientName: "Lime",
                displayName: "Misket Limonu",
                url: URL(string: "https://www.getir.com/ara?q=misket%20limonu")!,
                store: .getir
            ),
            IngredientMarketLink(
                ingredientName: "Lime",
                displayName: "Misket Limonu",
                url: URL(string: "https://www.migros.com.tr/arama?q=misket%20limonu")!,
                store: .migros
            )
        ],
        "Lemon Juice": [
            IngredientMarketLink(
                ingredientName: "Lemon Juice",
                displayName: "Limon Suyu",
                url: URL(string: "https://www.getir.com/ara?q=limon%20suyu")!,
                store: .getir
            )
        ],
        "Coconut Cream": [
            IngredientMarketLink(
                ingredientName: "Coconut Cream",
                displayName: "Hindistan Cevizi Kreması",
                url: URL(string: "https://www.trendyol.com/sr?q=hindistan%20cevizi%20kremasi")!,
                store: .trendyol
            ),
            IngredientMarketLink(
                ingredientName: "Coconut Cream",
                displayName: "Hindistan Cevizi Sütü",
                url: URL(string: "https://www.migros.com.tr/arama?q=hindistan%20cevizi%20sutu")!,
                store: .migros
            )
        ],
        "Coconut Milk": [
            IngredientMarketLink(
                ingredientName: "Coconut Milk",
                displayName: "Hindistan Cevizi Sütü",
                url: URL(string: "https://www.migros.com.tr/arama?q=hindistan%20cevizi%20sutu")!,
                store: .migros
            )
        ],
        "Mint": [
            IngredientMarketLink(
                ingredientName: "Mint",
                displayName: "Taze Nane",
                url: URL(string: "https://www.getir.com/ara?q=taze%20nane")!,
                store: .getir
            ),
            IngredientMarketLink(
                ingredientName: "Mint",
                displayName: "Nane",
                url: URL(string: "https://www.migros.com.tr/arama?q=nane")!,
                store: .migros
            )
        ],
        "Ginger Beer": [
            IngredientMarketLink(
                ingredientName: "Ginger Beer",
                displayName: "Ginger Beer",
                url: URL(string: "https://www.trendyol.com/sr?q=ginger%20beer")!,
                store: .trendyol
            )
        ],
        "Ginger Ale": [
            IngredientMarketLink(
                ingredientName: "Ginger Ale",
                displayName: "Ginger Ale",
                url: URL(string: "https://www.migros.com.tr/arama?q=ginger%20ale")!,
                store: .migros
            )
        ],
        "Tonic Water": [
            IngredientMarketLink(
                ingredientName: "Tonic Water",
                displayName: "Tonik",
                url: URL(string: "https://www.migros.com.tr/arama?q=tonik")!,
                store: .migros
            ),
            IngredientMarketLink(
                ingredientName: "Tonic Water",
                displayName: "Tonik",
                url: URL(string: "https://www.getir.com/ara?q=tonik")!,
                store: .getir
            )
        ],
        "Club Soda": [
            IngredientMarketLink(
                ingredientName: "Club Soda",
                displayName: "Soda",
                url: URL(string: "https://www.getir.com/ara?q=soda")!,
                store: .getir
            )
        ],
        "Cranberry Juice": [
            IngredientMarketLink(
                ingredientName: "Cranberry Juice",
                displayName: "Kızılcık Suyu",
                url: URL(string: "https://www.migros.com.tr/arama?q=kizilcik%20suyu")!,
                store: .migros
            )
        ],
        "Orange Juice": [
            IngredientMarketLink(
                ingredientName: "Orange Juice",
                displayName: "Portakal Suyu",
                url: URL(string: "https://www.getir.com/ara?q=portakal%20suyu")!,
                store: .getir
            )
        ],
        "Pineapple Juice": [
            IngredientMarketLink(
                ingredientName: "Pineapple Juice",
                displayName: "Ananas Suyu",
                url: URL(string: "https://www.migros.com.tr/arama?q=ananas%20suyu")!,
                store: .migros
            )
        ],
        "Cream": [
            IngredientMarketLink(
                ingredientName: "Cream",
                displayName: "Krema",
                url: URL(string: "https://www.getir.com/ara?q=krema")!,
                store: .getir
            )
        ],
        "Heavy Cream": [
            IngredientMarketLink(
                ingredientName: "Heavy Cream",
                displayName: "Krema",
                url: URL(string: "https://www.migros.com.tr/arama?q=krema")!,
                store: .migros
            )
        ],
        "Egg White": [
            IngredientMarketLink(
                ingredientName: "Egg White",
                displayName: "Yumurta",
                url: URL(string: "https://www.getir.com/ara?q=yumurta")!,
                store: .getir
            )
        ],
        "Sugar": [
            IngredientMarketLink(
                ingredientName: "Sugar",
                displayName: "Şeker",
                url: URL(string: "https://www.getir.com/ara?q=seker")!,
                store: .getir
            )
        ],
        "Brown Sugar": [
            IngredientMarketLink(
                ingredientName: "Brown Sugar",
                displayName: "Esmer Şeker",
                url: URL(string: "https://www.migros.com.tr/arama?q=esmer%20seker")!,
                store: .migros
            )
        ],
        "Honey": [
            IngredientMarketLink(
                ingredientName: "Honey",
                displayName: "Bal",
                url: URL(string: "https://www.getir.com/ara?q=bal")!,
                store: .getir
            )
        ],
        "Maraschino Cherry": [
            IngredientMarketLink(
                ingredientName: "Maraschino Cherry",
                displayName: "Kokteyl Kirazı",
                url: URL(string: "https://www.trendyol.com/sr?q=kokteyl%20kirazi")!,
                store: .trendyol
            )
        ],
        "Cherry": [
            IngredientMarketLink(
                ingredientName: "Cherry",
                displayName: "Kokteyl Kirazı",
                url: URL(string: "https://www.trendyol.com/sr?q=kokteyl%20kirazi")!,
                store: .trendyol
            )
        ],
        "Olive": [
            IngredientMarketLink(
                ingredientName: "Olive",
                displayName: "Zeytin",
                url: URL(string: "https://www.getir.com/ara?q=zeytin")!,
                store: .getir
            )
        ],
        "Salt": [
            IngredientMarketLink(
                ingredientName: "Salt",
                displayName: "Tuz",
                url: URL(string: "https://www.getir.com/ara?q=tuz")!,
                store: .getir
            )
        ],
        "Ice": [
            IngredientMarketLink(
                ingredientName: "Ice",
                displayName: "Buz",
                url: URL(string: "https://www.getir.com/ara?q=buz")!,
                store: .getir
            )
        ]
    ]
    
    static func getLinks(for ingredientName: String) -> [IngredientMarketLink] {
        return links[ingredientName] ?? []
    }
    
    static func hasLinks(for ingredientName: String) -> Bool {
        return links[ingredientName] != nil
    }
    
    static func generateSearchURL(for ingredientName: String, store: IngredientMarketLink.MarketStore) -> URL? {
        let encodedName = ingredientName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ingredientName
        
        switch store {
        case .trendyol:
            return URL(string: "https://www.trendyol.com/sr?q=\(encodedName)")
        case .hepsiburada:
            return URL(string: "https://www.hepsiburada.com/ara?q=\(encodedName)")
        case .migros:
            return URL(string: "https://www.migros.com.tr/arama?q=\(encodedName)")
        case .getir:
            return URL(string: "https://www.getir.com/ara?q=\(encodedName)")
        }
    }
}
