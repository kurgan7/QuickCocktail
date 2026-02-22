import SwiftUI

struct IngredientChip: View {
    let name: String
    let isSelected: Bool
    let onTap: () -> Void
    let onRemove: (() -> Void)?
    
    init(name: String, isSelected: Bool = false, onTap: @escaping () -> Void = {}, onRemove: (() -> Void)? = nil) {
        self.name = name
        self.isSelected = isSelected
        self.onTap = onTap
        self.onRemove = onRemove
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Text(name)
                .font(.subheadline)
                .fontWeight(.medium)
            
            if let onRemove = onRemove {
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                }
            }
        }
        .foregroundStyle(isSelected ? .white : .white.opacity(0.9))
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(isSelected ? Color.accentColor : Color.white.opacity(0.2))
        )
        .overlay(
            Capsule()
                .strokeBorder(isSelected ? Color.accentColor : Color.white.opacity(0.3), lineWidth: 1)
        )
        .contentShape(Capsule())
        .onTapGesture(perform: onTap)
    }
}

struct IngredientRow: View {
    let ingredient: IngredientItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                AsyncImage(url: ingredient.smallThumbnailURL) { phase in
                    switch phase {
                    case .empty:
                        Circle()
                            .fill(.ultraThinMaterial)
                            .overlay {
                                ProgressView()
                                    .scaleEffect(0.5)
                            }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Circle()
                            .fill(.ultraThinMaterial)
                            .overlay {
                                Image(systemName: "leaf.fill")
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 40, height: 40)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(ingredient.turkishName)
                        .font(.body)
                        .foregroundStyle(.white)
                    
                    if ingredient.turkishName != ingredient.name {
                        Text(ingredient.name)
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(Color.accentColor)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.accentColor.opacity(0.2) : Color.white.opacity(0.1))
            )
        }
        .buttonStyle(.plain)
    }
}

struct SelectedIngredientsView: View {
    let ingredients: [SelectedIngredient]
    let onRemove: (SelectedIngredient) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ingredients) { ingredient in
                    IngredientChip(
                        name: ingredient.turkishName,
                        isSelected: true,
                        onRemove: { onRemove(ingredient) }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ZStack {
        AnimatedBackground()
        
        VStack(spacing: 20) {
            HStack {
                IngredientChip(name: "Vodka", isSelected: true, onRemove: {})
                IngredientChip(name: "Lime", isSelected: false)
                IngredientChip(name: "Mint", isSelected: true, onRemove: {})
            }
        }
        .padding()
    }
}
