import Foundation

struct TranslationService {
    
    // MARK: - Ingredient Translations (English -> Turkish)
    static let ingredientTranslations: [String: String] = [
        // Spirits - İçkiler
        "Vodka": "Votka",
        "Gin": "Cin",
        "Rum": "Rom",
        "Light Rum": "Beyaz Rom",
        "Dark Rum": "Koyu Rom",
        "White Rum": "Beyaz Rom",
        "Gold Rum": "Altın Rom",
        "Spiced Rum": "Baharatlı Rom",
        "Coconut Rum": "Hindistan Cevizi Romu",
        "Tequila": "Tekila",
        "Whiskey": "Viski",
        "Whisky": "Viski",
        "Bourbon": "Burbon",
        "Scotch": "İskoç Viskisi",
        "Rye Whiskey": "Çavdar Viskisi",
        "Irish Whiskey": "İrlanda Viskisi",
        "Brandy": "Brendi",
        "Cognac": "Konyak",
        "Mezcal": "Meskal",
        
        // Liqueurs - Likörler
        "Triple Sec": "Triple Sec",
        "Cointreau": "Cointreau",
        "Grand Marnier": "Grand Marnier",
        "Blue Curacao": "Mavi Curacao",
        "Amaretto": "Amaretto",
        "Kahlua": "Kahlua",
        "Coffee Liqueur": "Kahve Likörü",
        "Baileys Irish Cream": "Baileys",
        "Irish Cream": "İrlanda Kreması",
        "Chambord": "Chambord",
        "Midori": "Midori",
        "Melon Liqueur": "Kavun Likörü",
        "Peach Schnapps": "Şeftali Şnaps",
        "Schnapps": "Şnaps",
        "Creme de Cacao": "Kakao Kreması",
        "Creme de Menthe": "Nane Kreması",
        "Maraschino Liqueur": "Maraschino Likörü",
        "Frangelico": "Frangelico",
        "Campari": "Campari",
        "Aperol": "Aperol",
        "Jagermeister": "Jägermeister",
        "Absinthe": "Absint",
        "Sambuca": "Sambuka",
        "Drambuie": "Drambuie",
        "Galliano": "Galliano",
        "Chartreuse": "Chartreuse",
        "Benedictine": "Benedictine",
        "St. Germain": "St. Germain",
        "Elderflower Liqueur": "Mürver Çiçeği Likörü",
        
        // Wines & Champagne - Şarap ve Şampanya
        "Champagne": "Şampanya",
        "Prosecco": "Prosecco",
        "Sparkling Wine": "Köpüklü Şarap",
        "Red Wine": "Kırmızı Şarap",
        "White Wine": "Beyaz Şarap",
        "Dry Vermouth": "Kuru Vermut",
        "Sweet Vermouth": "Tatlı Vermut",
        "Vermouth": "Vermut",
        "Port": "Porto Şarabı",
        "Sherry": "Şeri",
        
        // Mixers - Karıştırıcılar
        "Soda Water": "Soda",
        "Club Soda": "Soda",
        "Tonic Water": "Tonik",
        "Ginger Ale": "Zencefil Gazozı",
        "Ginger Beer": "Zencefil Birası",
        "Cola": "Kola",
        "Coca-Cola": "Coca-Cola",
        "Sprite": "Sprite",
        "Lemon-Lime Soda": "Limonlu Gazoz",
        "7-Up": "7-Up",
        "Red Bull": "Red Bull",
        "Energy Drink": "Enerji İçeceği",
        "Water": "Su",
        "Hot Water": "Sıcak Su",
        "Milk": "Süt",
        "Cream": "Krema",
        "Heavy Cream": "Yoğun Krema",
        "Light Cream": "Hafif Krema",
        "Half-and-Half": "Yarım Krema",
        "Coconut Milk": "Hindistan Cevizi Sütü",
        "Coconut Cream": "Hindistan Cevizi Kreması",
        "Almond Milk": "Badem Sütü",
        
        // Juices - Meyve Suları
        "Orange Juice": "Portakal Suyu",
        "Lemon Juice": "Limon Suyu",
        "Lime Juice": "Misket Limonu Suyu",
        "Grapefruit Juice": "Greyfurt Suyu",
        "Pineapple Juice": "Ananas Suyu",
        "Cranberry Juice": "Kızılcık Suyu",
        "Apple Juice": "Elma Suyu",
        "Tomato Juice": "Domates Suyu",
        "Grape Juice": "Üzüm Suyu",
        "Passion Fruit Juice": "Çarkıfelek Suyu",
        "Mango Juice": "Mango Suyu",
        "Peach Juice": "Şeftali Suyu",
        "Pomegranate Juice": "Nar Suyu",
        "Carrot Juice": "Havuç Suyu",
        
        // Fruits - Meyveler
        "Lemon": "Limon",
        "Lime": "Misket Limonu",
        "Orange": "Portakal",
        "Grapefruit": "Greyfurt",
        "Pineapple": "Ananas",
        "Strawberry": "Çilek",
        "Strawberries": "Çilek",
        "Raspberry": "Ahududu",
        "Raspberries": "Ahududu",
        "Blueberry": "Yaban Mersini",
        "Blueberries": "Yaban Mersini",
        "Blackberry": "Böğürtlen",
        "Cherry": "Kiraz",
        "Maraschino Cherry": "Kokteyl Kirazı",
        "Apple": "Elma",
        "Banana": "Muz",
        "Mango": "Mango",
        "Peach": "Şeftali",
        "Watermelon": "Karpuz",
        "Melon": "Kavun",
        "Coconut": "Hindistan Cevizi",
        "Passion Fruit": "Çarkıfelek",
        "Kiwi": "Kivi",
        "Grapes": "Üzüm",
        "Olive": "Zeytin",
        "Olives": "Zeytin",
        
        // Herbs & Spices - Otlar ve Baharatlar
        "Mint": "Nane",
        "Fresh Mint": "Taze Nane",
        "Mint Leaves": "Nane Yaprakları",
        "Basil": "Fesleğen",
        "Rosemary": "Biberiye",
        "Thyme": "Kekik",
        "Cinnamon": "Tarçın",
        "Nutmeg": "Hindistan Cevizi",
        "Ginger": "Zencefil",
        "Fresh Ginger": "Taze Zencefil",
        "Cloves": "Karanfil",
        "Vanilla": "Vanilya",
        "Vanilla Extract": "Vanilya Özütü",
        "Pepper": "Biber",
        "Black Pepper": "Karabiber",
        "Cayenne Pepper": "Acı Biber",
        "Chili": "Acı Biber",
        "Jalapeño": "Jalapeno",
        "Cucumber": "Salatalık",
        "Celery": "Kereviz",
        
        // Sweeteners - Tatlandırıcılar
        "Sugar": "Şeker",
        "Brown Sugar": "Esmer Şeker",
        "Powdered Sugar": "Pudra Şekeri",
        "Simple Syrup": "Şeker Şurubu",
        "Sugar Syrup": "Şeker Şurubu",
        "Honey": "Bal",
        "Agave Syrup": "Agave Şurubu",
        "Maple Syrup": "Akçaağaç Şurubu",
        "Grenadine": "Grenadine",
        "Orgeat Syrup": "Orgeat Şurubu",
        "Raspberry Syrup": "Ahududu Şurubu",
        "Strawberry Syrup": "Çilek Şurubu",
        "Vanilla Syrup": "Vanilya Şurubu",
        "Caramel Syrup": "Karamel Şurubu",
        "Chocolate Syrup": "Çikolata Şurubu",
        
        // Bitters & Others - Biterler ve Diğerleri
        "Angostura Bitters": "Angostura Bitter",
        "Bitters": "Bitter",
        "Orange Bitters": "Portakal Biteri",
        "Peychaud's Bitters": "Peychaud's Bitter",
        "Aromatic Bitters": "Aromatik Bitter",
        
        // Dairy & Eggs - Süt Ürünleri ve Yumurta
        "Egg": "Yumurta",
        "Egg White": "Yumurta Akı",
        "Egg Yolk": "Yumurta Sarısı",
        "Whole Egg": "Tam Yumurta",
        "Butter": "Tereyağı",
        "Yogurt": "Yoğurt",
        "Ice Cream": "Dondurma",
        "Whipped Cream": "Krem Şanti",
        
        // Other - Diğer
        "Ice": "Buz",
        "Crushed Ice": "Kırık Buz",
        "Salt": "Tuz",
        "Coarse Salt": "İri Tuz",
        "Tabasco Sauce": "Tabasco Sosu",
        "Hot Sauce": "Acı Sos",
        "Worcestershire Sauce": "Worcestershire Sosu",
        "Soy Sauce": "Soya Sosu",
        "Coffee": "Kahve",
        "Espresso": "Espresso",
        "Tea": "Çay",
        "Chocolate": "Çikolata",
        "Dark Chocolate": "Bitter Çikolata",
        "White Chocolate": "Beyaz Çikolata",
        "Cocoa Powder": "Kakao Tozu",
        "Nutella": "Nutella",
        "Peanut Butter": "Fıstık Ezmesi",
    ]
    
    // MARK: - Category Translations
    static let categoryTranslations: [String: String] = [
        "Ordinary Drink": "Klasik Kokteyl",
        "Cocktail": "Kokteyl",
        "Shot": "Shot",
        "Coffee / Tea": "Kahve / Çay",
        "Homemade Liqueur": "Ev Yapımı Likör",
        "Punch / Party Drink": "Punch / Parti İçeceği",
        "Beer": "Bira",
        "Soft Drink": "Meşrubat",
        "Shake": "Shake",
        "Cocoa": "Kakao",
        "Other/Unknown": "Diğer",
    ]
    
    // MARK: - Glass Type Translations
    static let glassTranslations: [String: String] = [
        "Highball glass": "Highball Bardağı",
        "Cocktail glass": "Kokteyl Bardağı",
        "Old-fashioned glass": "Old Fashioned Bardağı",
        "Whiskey Glass": "Viski Bardağı",
        "Collins glass": "Collins Bardağı",
        "Martini Glass": "Martini Bardağı",
        "Margarita glass": "Margarita Bardağı",
        "Hurricane glass": "Hurricane Bardağı",
        "Champagne flute": "Şampanya Flütü",
        "Wine Glass": "Şarap Bardağı",
        "Shot glass": "Shot Bardağı",
        "Beer mug": "Bira Bardağı",
        "Beer Glass": "Bira Bardağı",
        "Irish coffee cup": "İrlanda Kahve Fincanı",
        "Coffee mug": "Kahve Fincanı",
        "Copper Mug": "Bakır Kupa",
        "Mason jar": "Kavanoz",
        "Punch bowl": "Punch Kasesi",
        "Pitcher": "Sürahi",
        "Coupe Glass": "Coupe Bardağı",
        "Nick and Nora Glass": "Nick and Nora Bardağı",
        "Brandy snifter": "Konyak Bardağı",
    ]
    
    // MARK: - Translation Methods
    
    static func translateIngredient(_ english: String) -> String {
        // Önce tam eşleşme ara
        if let translation = ingredientTranslations[english] {
            return translation
        }
        
        // Küçük harflerle dene
        let lowercased = english.lowercased()
        for (key, value) in ingredientTranslations {
            if key.lowercased() == lowercased {
                return value
            }
        }
        
        // Kısmi eşleşme dene
        for (key, value) in ingredientTranslations {
            if english.lowercased().contains(key.lowercased()) {
                return value
            }
        }
        
        // Bulunamazsa orijinal döndür
        return english
    }
    
    static func translateCategory(_ english: String) -> String {
        return categoryTranslations[english] ?? english
    }
    
    static func translateGlass(_ english: String) -> String {
        return glassTranslations[english] ?? english
    }
    
    // MARK: - Reverse Translation (Turkish -> English for API)
    
    static func getEnglishIngredient(_ turkish: String) -> String {
        for (english, tr) in ingredientTranslations {
            if tr.lowercased() == turkish.lowercased() {
                return english
            }
        }
        return turkish
    }
    
    // MARK: - Search Helper
    
    static func normalizeForSearch(_ text: String) -> String {
        var normalized = text.lowercased()
        normalized = normalized.replacingOccurrences(of: "ı", with: "i")
        normalized = normalized.replacingOccurrences(of: "ğ", with: "g")
        normalized = normalized.replacingOccurrences(of: "ü", with: "u")
        normalized = normalized.replacingOccurrences(of: "ş", with: "s")
        normalized = normalized.replacingOccurrences(of: "ö", with: "o")
        normalized = normalized.replacingOccurrences(of: "ç", with: "c")
        return normalized
    }
    
    static func searchIngredients(query: String, in ingredients: [IngredientItem]) -> [IngredientItem] {
        let normalizedQuery = normalizeForSearch(query)
        
        return ingredients.filter { ingredient in
            // İngilizce isimde ara
            let normalizedEnglish = normalizeForSearch(ingredient.name)
            if normalizedEnglish.contains(normalizedQuery) {
                return true
            }
            
            // Türkçe çeviride ara
            let turkishName = translateIngredient(ingredient.name)
            let normalizedTurkish = normalizeForSearch(turkishName)
            if normalizedTurkish.contains(normalizedQuery) {
                return true
            }
            
            return false
        }
    }
}

// MARK: - Ingredient Extension for Translation

extension IngredientItem {
    var turkishName: String {
        TranslationService.translateIngredient(name)
    }
    
    var displayName: String {
        let turkish = turkishName
        if turkish != name {
            return "\(turkish)"
        }
        return name
    }
}

// MARK: - Cocktail Extension for Translation

extension Cocktail {
    var turkishCategory: String {
        TranslationService.translateCategory(category)
    }
    
    var turkishGlassType: String {
        TranslationService.translateGlass(glassType)
    }
    
    var translatedIngredientsWithMeasures: [(ingredient: String, englishIngredient: String, measure: String)] {
        ingredientsWithMeasures.map { item in
            let turkish = TranslationService.translateIngredient(item.ingredient)
            return (turkish, item.ingredient, item.measure)
        }
    }
}
