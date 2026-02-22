import SwiftUI

struct CocktailResultsView: View {
    let searchResults: [CocktailMatchResult]
    let selectedIngredients: [SelectedIngredient]
    
    @Environment(\.dismiss) private var dismiss
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    private var perfectMatches: [CocktailMatchResult] {
        searchResults.filter { $0.isPerfectMatch }
    }
    
    private var partialMatches: [CocktailMatchResult] {
        searchResults.filter { !$0.isPerfectMatch }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackground()
                
                if searchResults.isEmpty {
                    emptyStateView
                } else {
                    resultsContent
                }
            }
            .navigationTitle("Sonuçlar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Kapat") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
        }
    }
    
    private var resultsContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                resultsSummary
                
                if !perfectMatches.isEmpty {
                    matchSection(
                        title: "Tüm Malzemeler Var",
                        subtitle: "Bu kokteyller seçtiğiniz tüm malzemeleri içeriyor",
                        icon: "checkmark.seal.fill",
                        iconColor: .green,
                        results: perfectMatches
                    )
                }
                
                if !partialMatches.isEmpty {
                    matchSection(
                        title: "Kısmi Eşleşme",
                        subtitle: "Bu kokteyller bazı malzemeleri içeriyor",
                        icon: "chart.pie.fill",
                        iconColor: .orange,
                        results: partialMatches
                    )
                }
            }
            .padding(.bottom, 100)
        }
    }
    
    private var resultsSummary: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(searchResults.count) kokteyl bulundu!")
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    if !perfectMatches.isEmpty {
                        Text("\(perfectMatches.count) tanesi tüm malzemeleri içeriyor")
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                }
                
                Spacer()
                
                if !perfectMatches.isEmpty {
                    ZStack {
                        Circle()
                            .fill(.green.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Text("\(perfectMatches.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.green)
                    }
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    Text("Malzemeler:")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                    
                    ForEach(selectedIngredients) { ingredient in
                        Text(ingredient.turkishName)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.accentColor.opacity(0.6))
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        .padding(.top)
    }
    
    private func matchSection(title: String, subtitle: String, icon: String, iconColor: Color, results: [CocktailMatchResult]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(iconColor)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                }
                
                Spacer()
                
                Text("\(results.count)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.white.opacity(0.1))
                    .clipShape(Capsule())
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(results) { result in
                    NavigationLink(destination: CocktailDetailView(cocktailId: result.cocktail.id)) {
                        CocktailMatchCard(result: result)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "wineglass")
                .font(.system(size: 60))
                .foregroundStyle(.white.opacity(0.5))
            
            Text("Kokteyl Bulunamadı")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Text("Seçtiğiniz malzemelerle yapılabilecek bir kokteyl bulunamadı. Farklı malzemeler deneyebilirsiniz.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button("Geri Dön") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
            
            Spacer()
        }
    }
}

struct CocktailMatchCard: View {
    let result: CocktailMatchResult
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: result.cocktail.thumbnailURL) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .overlay {
                                ProgressView()
                            }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .overlay {
                                Image(systemName: "wineglass.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 140)
                .clipped()
                
                matchBadge
                    .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(result.cocktail.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    ForEach(0..<result.totalIngredients, id: \.self) { index in
                        Circle()
                            .fill(index < result.matchCount ? Color.green : Color.white.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                    
                    Spacer()
                    
                    Text(result.matchLabel)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(result.isPerfectMatch ? Color.green.opacity(0.5) : Color.clear, lineWidth: 2)
        )
    }
    
    private var matchBadge: some View {
        HStack(spacing: 4) {
            if result.isPerfectMatch {
                Image(systemName: "checkmark")
                    .font(.caption2)
            }
            Text("\(result.matchCount)/\(result.totalIngredients)")
                .font(.caption2)
                .fontWeight(.bold)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(result.isPerfectMatch ? Color.green : Color.orange)
        .clipShape(Capsule())
    }
}

#Preview {
    CocktailResultsView(
        searchResults: [],
        selectedIngredients: [
            SelectedIngredient(name: "Vodka"),
            SelectedIngredient(name: "Lime")
        ]
    )
}
