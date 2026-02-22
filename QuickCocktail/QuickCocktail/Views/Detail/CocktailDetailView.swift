import SwiftUI
import SwiftData

struct CocktailDetailView: View {
    let cocktailId: String
    
    @StateObject private var viewModel = CocktailDetailViewModel()
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showAddedToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            if viewModel.isLoading {
                loadingView
            } else if let error = viewModel.errorMessage {
                errorView(message: error)
            } else if let cocktail = viewModel.cocktail {
                cocktailContent(cocktail)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack(spacing: 12) {
                    ShareLink(
                        item: "Check out this cocktail: \(viewModel.cocktail?.name ?? "")",
                        preview: SharePreview(
                            viewModel.cocktail?.name ?? "Cocktail",
                            image: Image(systemName: "wineglass.fill")
                        )
                    ) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(.white)
                    }
                    
                    Button(action: {
                        viewModel.toggleFavorite(modelContext: modelContext)
                    }) {
                        Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(viewModel.isFavorite ? .red : .white)
                    }
                }
            }
        }
        .task {
            await viewModel.loadCocktail(id: cocktailId, modelContext: modelContext)
        }
        .toast(isPresented: $showAddedToast, message: toastMessage, type: .success)
    }
    
    private func addToShoppingList(_ ingredientName: String) {
        let item = ShoppingListItem(
            ingredientName: ingredientName,
            fromCocktail: viewModel.cocktail?.name
        )
        modelContext.insert(item)
        try? modelContext.save()
        
        toastMessage = "\(ingredientName) listeye eklendi"
        showAddedToast = true
    }
    
    private func addAllToShoppingList(_ cocktail: Cocktail) {
        for item in cocktail.translatedIngredientsWithMeasures {
            let ingredientName = item.englishIngredient
            let descriptor = FetchDescriptor<ShoppingListItem>(
                predicate: #Predicate<ShoppingListItem> { listItem in
                    listItem.ingredientName == ingredientName
                }
            )
            
            if let existing = try? modelContext.fetch(descriptor), existing.isEmpty {
                let newItem = ShoppingListItem(
                    ingredientName: item.englishIngredient,
                    fromCocktail: cocktail.name
                )
                modelContext.insert(newItem)
            }
        }
        try? modelContext.save()
        
        toastMessage = "Tüm malzemeler listeye eklendi"
        showAddedToast = true
    }
    
    private func cocktailContent(_ cocktail: Cocktail) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                heroImage(cocktail)
                
                VStack(spacing: 24) {
                    headerInfo(cocktail)
                    
                    ingredientsSection(cocktail)
                    
                    instructionsSection(cocktail)
                }
                .padding()
                .padding(.bottom, 100)
            }
        }
        .ignoresSafeArea(edges: .top)
    }
    
    private func heroImage(_ cocktail: Cocktail) -> some View {
        GeometryReader { geometry in
            let minY = geometry.frame(in: .global).minY
            let height = max(300, 300 + minY)
            
            AsyncImage(url: cocktail.thumbnailURL) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .overlay {
                            ProgressView()
                                .tint(.white)
                        }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.system(size: 50))
                                .foregroundStyle(.white.opacity(0.5))
                        }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: geometry.size.width, height: height)
            .clipped()
            .offset(y: minY > 0 ? -minY : 0)
        }
        .frame(height: 300)
    }
    
    private func headerInfo(_ cocktail: Cocktail) -> some View {
        VStack(spacing: 12) {
            Text(cocktail.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                Label(cocktail.turkishCategory, systemImage: "tag.fill")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
                
                Label(cocktail.turkishGlassType, systemImage: "wineglass.fill")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            HStack(spacing: 12) {
                Text(cocktail.alcoholicLabel)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(cocktail.isAlcoholic ? Color.orange : Color.green)
                    .clipShape(Capsule())
                
                Text(cocktail.difficultyLevel)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(difficultyColor(cocktail.difficultyLevel))
                    .clipShape(Capsule())
            }
        }
    }
    
    private func ingredientsSection(_ cocktail: Cocktail) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "list.bullet.clipboard.fill")
                    .foregroundStyle(Color.accentColor)
                
                Text("Malzemeler")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button(action: { addAllToShoppingList(cocktail) }) {
                    HStack(spacing: 4) {
                        Image(systemName: "cart.badge.plus")
                        Text("Tümünü Ekle")
                            .font(.caption)
                    }
                    .foregroundStyle(Color.accentColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.accentColor.opacity(0.2))
                    .clipShape(Capsule())
                }
            }
            
            VStack(spacing: 0) {
                ForEach(Array(cocktail.translatedIngredientsWithMeasures.enumerated()), id: \.offset) { index, item in
                    ingredientRow(
                        ingredient: item.ingredient,
                        englishIngredient: item.englishIngredient,
                        measure: item.measure,
                        isLast: index == cocktail.translatedIngredientsWithMeasures.count - 1
                    )
                }
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private func ingredientRow(ingredient: String, englishIngredient: String, measure: String, isLast: Bool) -> some View {
        VStack(spacing: 0) {
            HStack {
                AsyncImage(url: ingredientImageURL(englishIngredient)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    default:
                        Circle()
                            .fill(.white.opacity(0.2))
                            .overlay {
                                Image(systemName: "leaf.fill")
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                    }
                }
                .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(ingredient)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                    
                    HStack(spacing: 4) {
                        if ingredient != englishIngredient {
                            Text(englishIngredient)
                                .font(.caption2)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                        
                        if !measure.isEmpty {
                            if ingredient != englishIngredient {
                                Text("•")
                                    .font(.caption2)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                            Text(measure)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.7))
                        }
                    }
                }
                
                Spacer()
                
                Button(action: { addToShoppingList(englishIngredient) }) {
                    Image(systemName: "plus.circle")
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.6))
                }
                
                if IngredientMarketLinks.hasLinks(for: englishIngredient) {
                    Menu {
                        ForEach(viewModel.getMarketLinks(for: englishIngredient)) { link in
                            Link(destination: link.url) {
                                Label(link.store.rawValue, systemImage: link.store.iconName)
                            }
                        }
                    } label: {
                        Image(systemName: "cart.fill")
                            .font(.body)
                            .foregroundStyle(Color.accentColor)
                            .padding(8)
                            .background(Color.accentColor.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
            }
            .padding()
            
            if !isLast {
                Divider()
                    .background(.white.opacity(0.2))
            }
        }
    }
    
    private func instructionsSection(_ cocktail: Cocktail) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "book.fill")
                    .foregroundStyle(Color.accentColor)
                
                Text("Hazırlanışı")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            
            Text(cocktail.instructions)
                .font(.body)
                .foregroundStyle(.white.opacity(0.9))
                .lineSpacing(6)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)
            
            Text("Kokteyl yükleniyor...")
                .foregroundStyle(.white.opacity(0.8))
        }
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundStyle(.orange)
            
            Text("Bir hata oluştu")
                .font(.headline)
                .foregroundStyle(.white)
            
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button("Tekrar Dene") {
                Task {
                    await viewModel.loadCocktail(id: cocktailId, modelContext: modelContext)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func ingredientImageURL(_ ingredient: String) -> URL? {
        let encodedName = ingredient.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ingredient
        return URL(string: "https://www.thecocktaildb.com/images/ingredients/\(encodedName)-Small.png")
    }
    
    private func difficultyColor(_ level: String) -> Color {
        switch level {
        case "Kolay": return .green
        case "Orta": return .orange
        default: return .red
        }
    }
}

#Preview {
    NavigationStack {
        CocktailDetailView(cocktailId: "11007")
    }
    .modelContainer(for: [FavoriteCocktail.self, CocktailHistory.self, ShoppingListItem.self], inMemory: true)
}
