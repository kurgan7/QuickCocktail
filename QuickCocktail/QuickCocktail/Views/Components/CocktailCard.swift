import SwiftUI

struct CocktailCard: View {
    let name: String
    let imageURL: URL?
    let category: String?
    let isAlcoholic: Bool?
    
    init(name: String, imageURL: URL?, category: String? = nil, isAlcoholic: Bool? = nil) {
        self.name = name
        self.imageURL = imageURL
        self.category = category
        self.isAlcoholic = isAlcoholic
    }
    
    init(cocktail: Cocktail) {
        self.name = cocktail.name
        self.imageURL = cocktail.previewThumbnailURL
        self.category = cocktail.category
        self.isAlcoholic = cocktail.isAlcoholic
    }
    
    init(summary: CocktailSummary) {
        self.name = summary.name
        self.imageURL = summary.previewThumbnailURL
        self.category = nil
        self.isAlcoholic = nil
    }
    
    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: imageURL) { phase in
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
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                if let category = category {
                    Text(category)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(.ultraThinMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct LargeCocktailCard: View {
    let cocktail: Cocktail
    let onRefresh: (() -> Void)?
    
    init(cocktail: Cocktail, onRefresh: (() -> Void)? = nil) {
        self.cocktail = cocktail
        self.onRefresh = onRefresh
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
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
                .frame(height: 200)
                .clipped()
                
                if let onRefresh = onRefresh {
                    Button(action: onRefresh) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .padding(12)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(cocktail.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Text(cocktail.alcoholicLabel)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(cocktail.isAlcoholic ? Color.orange.opacity(0.8) : Color.green.opacity(0.8))
                        .clipShape(Capsule())
                }
                
                HStack(spacing: 16) {
                    Label(cocktail.category, systemImage: "tag.fill")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Label(cocktail.glassType, systemImage: "wineglass.fill")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Spacer()
                    
                    Text(cocktail.difficultyLevel)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(difficultyColor.opacity(0.8))
                        .clipShape(Capsule())
                }
            }
            .padding(16)
            .background(.ultraThinMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 6)
    }
    
    private var difficultyColor: Color {
        switch cocktail.difficultyLevel {
        case "Kolay": return .green
        case "Orta": return .orange
        default: return .red
        }
    }
}

struct HorizontalCocktailCard: View {
    let name: String
    let imageURL: URL?
    let subtitle: String?
    
    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: imageURL) { phase in
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
                                .foregroundStyle(.white.opacity(0.5))
                        }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 120, height: 120)
            .clipped()
            
            VStack(spacing: 2) {
                Text(name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.7))
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(.ultraThinMaterial)
        }
        .frame(width: 120)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    ZStack {
        AnimatedBackground()
        
        VStack(spacing: 20) {
            CocktailCard(
                name: "Mojito",
                imageURL: URL(string: "https://www.thecocktaildb.com/images/media/drink/metwgh1606770327.jpg"),
                category: "Cocktail",
                isAlcoholic: true
            )
            .frame(width: 160)
        }
        .padding()
    }
}
