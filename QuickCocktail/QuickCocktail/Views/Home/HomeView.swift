import SwiftUI
import SwiftData

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showIngredientSearch = false
    @State private var showShoppingList = false
    @Query private var shoppingItems: [ShoppingListItem]
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackgroundWithBubbles()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        
                        quickActionsSection
                        
                        if let randomCocktail = viewModel.randomCocktail {
                            dailyCocktailSection(cocktail: randomCocktail)
                        }
                        
                        if !viewModel.popularCocktails.isEmpty {
                            popularCocktailsSection
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.top, 20)
                }
                .refreshable {
                    await viewModel.loadInitialData()
                }
                
                if viewModel.isLoading {
                    loadingOverlay
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Quick Cocktail")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showShoppingList = true }) {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "cart.fill")
                                .foregroundStyle(.white)
                            
                            if !shoppingItems.isEmpty {
                                Text("\(shoppingItems.count)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .padding(4)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: 8, y: -8)
                            }
                        }
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .sheet(isPresented: $showIngredientSearch) {
                IngredientSearchView()
            }
            .sheet(isPresented: $showShoppingList) {
                ShoppingListView()
            }
        }
        .task {
            await viewModel.loadInitialData()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "wineglass.fill")
                .font(.system(size: 50))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.accentColor, Color.accentColor.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            Text("Kokteyl Zamanı!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Text("Evdeki malzemelerle harika kokteyller keşfet")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
    }
    
    private var quickActionsSection: some View {
        VStack(spacing: 12) {
            Button(action: { showIngredientSearch = true }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Malzemelerimi Gir")
                            .font(.headline)
                        Text("Evde ne varsa seç, kokteyl bul")
                            .font(.caption)
                            .opacity(0.8)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.body)
                        .opacity(0.6)
                }
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: [Color.accentColor, Color.accentColor.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.accentColor.opacity(0.4), radius: 10, x: 0, y: 5)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
    }
    
    private func dailyCocktailSection(cocktail: Cocktail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Günün Kokteyli")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Image(systemName: "sparkles")
                    .foregroundStyle(Color.accentColor)
                
                Spacer()
            }
            .padding(.horizontal)
            
            NavigationLink(destination: CocktailDetailView(cocktailId: cocktail.id)) {
                LargeCocktailCard(cocktail: cocktail) {
                    Task {
                        await viewModel.refreshRandomCocktail()
                    }
                }
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
        }
    }
    
    private var popularCocktailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Popüler Kokteyller")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)
                
                Spacer()
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.popularCocktails) { cocktail in
                        NavigationLink(destination: CocktailDetailView(cocktailId: cocktail.id)) {
                            HorizontalCocktailCard(
                                name: cocktail.name,
                                imageURL: cocktail.previewThumbnailURL,
                                subtitle: cocktail.category
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
                
                Text("Yükleniyor...")
                    .font(.subheadline)
                    .foregroundStyle(.white)
            }
            .padding(30)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [FavoriteCocktail.self, CocktailHistory.self, ShoppingListItem.self], inMemory: true)
}
