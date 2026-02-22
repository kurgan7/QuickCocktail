import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Query(sort: \FavoriteCocktail.dateAdded, order: .reverse) private var favorites: [FavoriteCocktail]
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    
    private var filteredFavorites: [FavoriteCocktail] {
        if searchText.isEmpty {
            return favorites
        }
        return favorites.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackground()
                
                if favorites.isEmpty {
                    emptyStateView
                } else {
                    favoritesContent
                }
            }
            .navigationTitle("Favoriler")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .searchable(text: $searchText, prompt: "Favorilerde ara...")
        }
    }
    
    private var favoritesContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                statsHeader
                
                cocktailGrid
            }
            .padding(.bottom, 100)
        }
    }
    
    private var statsHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(favorites.count)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text("Favori Kokteyl")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "heart.fill")
                .font(.title)
                .foregroundStyle(.red)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var cocktailGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(filteredFavorites, id: \.cocktailId) { favorite in
                NavigationLink(destination: CocktailDetailView(cocktailId: favorite.cocktailId)) {
                    FavoriteCard(favorite: favorite)
                }
                .buttonStyle(.plain)
                .contextMenu {
                    Button(role: .destructive) {
                        deleteFavorite(favorite)
                    } label: {
                        Label("Favorilerden Kaldır", systemImage: "heart.slash.fill")
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundStyle(.white.opacity(0.5))
            
            Text("Henüz Favori Yok")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Text("Beğendiğiniz kokteylleri favorilere ekleyerek buradan kolayca erişebilirsiniz.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private func deleteFavorite(_ favorite: FavoriteCocktail) {
        withAnimation {
            modelContext.delete(favorite)
            try? modelContext.save()
        }
    }
}

struct FavoriteCard: View {
    let favorite: FavoriteCocktail
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: favorite.previewImageURL) { phase in
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
                                    .font(.largeTitle)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 140)
                .clipped()
                
                Image(systemName: "heart.fill")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(6)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(favorite.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(favorite.category)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(.ultraThinMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    FavoritesView()
        .modelContainer(for: [FavoriteCocktail.self, CocktailHistory.self], inMemory: true)
}
