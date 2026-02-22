import SwiftUI
import SwiftData

struct ShoppingListView: View {
    @Query(sort: \ShoppingListItem.dateAdded, order: .reverse) private var items: [ShoppingListItem]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    private var uncheckedItems: [ShoppingListItem] {
        items.filter { !$0.isChecked }
    }
    
    private var checkedItems: [ShoppingListItem] {
        items.filter { $0.isChecked }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackground()
                
                if items.isEmpty {
                    emptyStateView
                } else {
                    listContent
                }
            }
            .navigationTitle("Alışveriş Listesi")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Kapat") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
                
                if !checkedItems.isEmpty {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Temizle") {
                            clearCheckedItems()
                        }
                        .foregroundStyle(.red)
                    }
                }
            }
        }
    }
    
    private var listContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                statsHeader
                
                if !uncheckedItems.isEmpty {
                    itemsSection(title: "Alınacaklar", items: uncheckedItems)
                }
                
                if !checkedItems.isEmpty {
                    itemsSection(title: "Alınanlar", items: checkedItems, isChecked: true)
                }
            }
            .padding(.bottom, 100)
        }
    }
    
    private var statsHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(uncheckedItems.count)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text("Alınacak Malzeme")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Spacer()
            
            if !items.isEmpty {
                CircularProgressView(
                    progress: Double(checkedItems.count) / Double(items.count)
                )
                .frame(width: 50, height: 50)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        .padding(.top)
    }
    
    private func itemsSection(title: String, items: [ShoppingListItem], isChecked: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(isChecked ? .white.opacity(0.5) : .white)
                .padding(.horizontal)
            
            VStack(spacing: 8) {
                ForEach(items, id: \.ingredientName) { item in
                    ShoppingItemRow(item: item, onToggle: {
                        toggleItem(item)
                    }, onDelete: {
                        deleteItem(item)
                    })
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundStyle(.white.opacity(0.5))
            
            Text("Liste Boş")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Text("Kokteyl detay sayfasından eksik malzemeleri alışveriş listesine ekleyebilirsiniz.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private func toggleItem(_ item: ShoppingListItem) {
        withAnimation {
            item.isChecked.toggle()
            try? modelContext.save()
        }
    }
    
    private func deleteItem(_ item: ShoppingListItem) {
        withAnimation {
            modelContext.delete(item)
            try? modelContext.save()
        }
    }
    
    private func clearCheckedItems() {
        withAnimation {
            for item in checkedItems {
                modelContext.delete(item)
            }
            try? modelContext.save()
        }
    }
}

struct ShoppingItemRow: View {
    let item: ShoppingListItem
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    private var turkishName: String {
        TranslationService.translateIngredient(item.ingredientName)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(item.isChecked ? .green : .white.opacity(0.6))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(turkishName)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(item.isChecked ? .white.opacity(0.5) : .white)
                    .strikethrough(item.isChecked)
                
                HStack(spacing: 4) {
                    if turkishName != item.ingredientName {
                        Text(item.ingredientName)
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.4))
                    }
                    
                    if let cocktail = item.fromCocktail {
                        if turkishName != item.ingredientName {
                            Text("•")
                                .font(.caption2)
                                .foregroundStyle(.white.opacity(0.4))
                        }
                        Text(cocktail)
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }
            }
            
            Spacer()
            
            if item.hasMarketLinks {
                Menu {
                    ForEach(item.marketLinks) { link in
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
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.body)
                    .foregroundStyle(.red.opacity(0.8))
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.white.opacity(0.2), lineWidth: 4)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
            
            Text("\(Int(progress * 100))%")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    ShoppingListView()
        .modelContainer(for: [ShoppingListItem.self], inMemory: true)
}
