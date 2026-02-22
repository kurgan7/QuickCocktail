import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case noData
    case serverError(Int)
    case noInternet
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Bir hata oluştu. Lütfen tekrar deneyin."
        case .networkError:
            return "İnternet bağlantınızı kontrol edin ve tekrar deneyin."
        case .decodingError:
            return "Veriler yüklenirken bir sorun oluştu. Lütfen tekrar deneyin."
        case .noData:
            return "Aradığınız içerik bulunamadı."
        case .serverError:
            return "Sunucuya bağlanılamadı. Lütfen daha sonra tekrar deneyin."
        case .noInternet:
            return "İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin."
        }
    }
}

@MainActor
class CocktailAPIService: ObservableObject {
    static let shared = CocktailAPIService()
    
    private let baseURL = "https://www.thecocktaildb.com/api/json/v1/1"
    private let session: URLSession
    
    @Published var isLoading = false
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }
    
    private func fetch<T: Decodable>(_ endpoint: String) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.networkError(NSError(domain: "Invalid response", code: -1))
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.serverError(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func searchCocktailByName(_ name: String) async throws -> [Cocktail] {
        guard !name.isEmpty else { return [] }
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
        let response: CocktailResponse = try await fetch("/search.php?s=\(encodedName)")
        return response.drinks ?? []
    }
    
    func getCocktailById(_ id: String) async throws -> Cocktail? {
        let response: CocktailResponse = try await fetch("/lookup.php?i=\(id)")
        return response.drinks?.first
    }
    
    func getRandomCocktail() async throws -> Cocktail? {
        let response: CocktailResponse = try await fetch("/random.php")
        return response.drinks?.first
    }
    
    func filterByIngredient(_ ingredient: String) async throws -> [CocktailSummary] {
        guard !ingredient.isEmpty else { return [] }
        
        var allResults: [CocktailSummary] = []
        var seenIds = Set<String>()
        
        // Ana malzeme ile ara
        let encodedIngredient = ingredient.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ingredient
        let response: CocktailSummaryResponse = try await fetch("/filter.php?i=\(encodedIngredient)")
        for cocktail in response.drinks ?? [] {
            if !seenIds.contains(cocktail.id) {
                seenIds.insert(cocktail.id)
                allResults.append(cocktail)
            }
        }
        
        // Alternatif isimlerle de ara (örn: "Lime" için "Lime juice" da dene)
        let alternatives = Self.ingredientAlternatives[ingredient.lowercased()] ?? []
        for alt in alternatives {
            let encodedAlt = alt.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? alt
            if let altResponse: CocktailSummaryResponse = try? await fetch("/filter.php?i=\(encodedAlt)") {
                for cocktail in altResponse.drinks ?? [] {
                    if !seenIds.contains(cocktail.id) {
                        seenIds.insert(cocktail.id)
                        allResults.append(cocktail)
                    }
                }
            }
        }
        
        return allResults
    }
    
    // Malzeme alternatifleri - bazı malzemeler farklı isimlerle geçiyor olabilir
    static let ingredientAlternatives: [String: [String]] = [
        "lime": ["Lime juice"],
        "lime juice": ["Lime"],
        "lemon": ["Lemon juice"],
        "lemon juice": ["Lemon"],
        "orange": ["Orange juice"],
        "orange juice": ["Orange"],
        "rum": ["Light rum", "White rum", "Dark rum"],
        "light rum": ["Rum", "White rum"],
        "white rum": ["Rum", "Light rum"],
        "dark rum": ["Rum"],
        "whiskey": ["Whisky", "Bourbon", "Scotch", "Rye whiskey"],
        "whisky": ["Whiskey", "Bourbon", "Scotch"],
        "bourbon": ["Whiskey", "Whisky"],
        "vodka": ["Absolut Vodka"],
        "tequila": ["Blanco Tequila", "Reposado Tequila"],
        "triple sec": ["Cointreau", "Grand Marnier"],
        "cointreau": ["Triple sec"],
        "simple syrup": ["Sugar syrup", "Sugar"],
        "sugar syrup": ["Simple syrup", "Sugar"],
        "soda": ["Soda water", "Club soda"],
        "soda water": ["Club soda", "Soda"],
        "club soda": ["Soda water", "Soda"],
        "cream": ["Heavy cream", "Light cream"],
        "mint": ["Fresh mint", "Mint leaves"],
        "fresh mint": ["Mint"],
    ]
    
    func filterByMultipleIngredients(_ ingredients: [String]) async throws -> [CocktailSummary] {
        guard !ingredients.isEmpty else { return [] }
        
        // Her malzeme için kokteylleri al ve eşleşme sayısını hesapla
        var cocktailMatchCount: [String: (cocktail: CocktailSummary, count: Int)] = [:]
        
        for ingredient in ingredients {
            let cocktails = try await filterByIngredient(ingredient)
            for cocktail in cocktails {
                if let existing = cocktailMatchCount[cocktail.id] {
                    cocktailMatchCount[cocktail.id] = (existing.cocktail, existing.count + 1)
                } else {
                    cocktailMatchCount[cocktail.id] = (cocktail, 1)
                }
            }
        }
        
        // Eşleşme sayısına göre sırala (çoktan aza)
        let sortedCocktails = cocktailMatchCount.values
            .sorted { $0.count > $1.count }
            .map { $0.cocktail }
        
        return sortedCocktails
    }
    
    func filterByMultipleIngredientsWithMatchInfo(_ ingredients: [String]) async throws -> [CocktailMatchResult] {
        guard !ingredients.isEmpty else { return [] }
        
        var cocktailMatchCount: [String: (cocktail: CocktailSummary, count: Int, matchedIngredients: [String])] = [:]
        
        for ingredient in ingredients {
            let cocktails = try await filterByIngredient(ingredient)
            for cocktail in cocktails {
                if var existing = cocktailMatchCount[cocktail.id] {
                    existing.count += 1
                    existing.matchedIngredients.append(ingredient)
                    cocktailMatchCount[cocktail.id] = existing
                } else {
                    cocktailMatchCount[cocktail.id] = (cocktail, 1, [ingredient])
                }
            }
        }
        
        // Eşleşme sayısına göre sırala
        let sortedResults = cocktailMatchCount.values
            .sorted { $0.count > $1.count }
            .map { CocktailMatchResult(
                cocktail: $0.cocktail,
                matchCount: $0.count,
                totalIngredients: ingredients.count,
                matchedIngredients: $0.matchedIngredients
            )}
        
        return sortedResults
    }
    
    func getAllIngredients() async throws -> [IngredientItem] {
        let response: IngredientListResponse = try await fetch("/list.php?i=list")
        return response.drinks ?? []
    }
    
    func filterByCategory(_ category: String) async throws -> [CocktailSummary] {
        let encodedCategory = category.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? category
        let response: CocktailSummaryResponse = try await fetch("/filter.php?c=\(encodedCategory)")
        return response.drinks ?? []
    }
    
    func filterByAlcoholic(_ isAlcoholic: Bool) async throws -> [CocktailSummary] {
        let filter = isAlcoholic ? "Alcoholic" : "Non_Alcoholic"
        let response: CocktailSummaryResponse = try await fetch("/filter.php?a=\(filter)")
        return response.drinks ?? []
    }
    
    func getPopularCocktails() async throws -> [Cocktail] {
        let popularNames = ["Margarita", "Mojito", "Cosmopolitan", "Mai Tai", "Pina Colada", "Long Island Iced Tea"]
        var cocktails: [Cocktail] = []
        
        for name in popularNames {
            if let results = try? await searchCocktailByName(name), let first = results.first {
                cocktails.append(first)
            }
        }
        
        return cocktails
    }
}

extension CocktailAPIService {
    func preloadData() async {
        _ = try? await getAllIngredients()
    }
}
