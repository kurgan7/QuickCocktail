import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \CocktailHistory.dateViewed, order: .reverse) private var history: [CocktailHistory]
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    
    private var filteredHistory: [CocktailHistory] {
        if searchText.isEmpty {
            return history
        }
        return history.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    private var groupedHistory: [(String, [CocktailHistory])] {
        let grouped = Dictionary(grouping: filteredHistory) { item in
            formatDateGroup(item.dateViewed)
        }
        
        let sortOrder = ["Bugün", "Dün", "Bu Hafta", "Bu Ay", "Daha Eski"]
        
        return sortOrder.compactMap { key in
            guard let items = grouped[key], !items.isEmpty else { return nil }
            return (key, items)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackground()
                
                if history.isEmpty {
                    emptyStateView
                } else {
                    historyContent
                }
            }
            .navigationTitle("Geçmiş")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                if !history.isEmpty {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Temizle") {
                            clearHistory()
                        }
                        .foregroundStyle(.red)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Geçmişte ara...")
        }
    }
    
    private var historyContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                statsHeader
                
                ForEach(groupedHistory, id: \.0) { group, items in
                    historySection(title: group, items: items)
                }
            }
            .padding(.bottom, 100)
        }
    }
    
    private var statsHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(history.count)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text("Görüntülenen Kokteyl")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Spacer()
            
            Image(systemName: "clock.fill")
                .font(.title)
                .foregroundStyle(Color.accentColor)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        .padding(.top)
    }
    
    private func historySection(title: String, items: [CocktailHistory]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.horizontal)
            
            VStack(spacing: 8) {
                ForEach(items, id: \.cocktailId) { item in
                    NavigationLink(destination: CocktailDetailView(cocktailId: item.cocktailId)) {
                        HistoryRow(item: item)
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button(role: .destructive) {
                            deleteHistoryItem(item)
                        } label: {
                            Label("Geçmişten Kaldır", systemImage: "trash.fill")
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "clock")
                .font(.system(size: 60))
                .foregroundStyle(.white.opacity(0.5))
            
            Text("Geçmiş Boş")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            Text("Görüntülediğiniz kokteyller burada listelenecek.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private func formatDateGroup(_ date: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Bugün"
        } else if calendar.isDateInYesterday(date) {
            return "Dün"
        } else if let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()),
                  date > weekAgo {
            return "Bu Hafta"
        } else if let monthAgo = calendar.date(byAdding: .month, value: -1, to: Date()),
                  date > monthAgo {
            return "Bu Ay"
        } else {
            return "Daha Eski"
        }
    }
    
    private func deleteHistoryItem(_ item: CocktailHistory) {
        withAnimation {
            modelContext.delete(item)
            try? modelContext.save()
        }
    }
    
    private func clearHistory() {
        withAnimation {
            for item in history {
                modelContext.delete(item)
            }
            try? modelContext.save()
        }
    }
}

struct HistoryRow: View {
    let item: CocktailHistory
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: item.previewImageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                default:
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .overlay {
                            Image(systemName: "wineglass.fill")
                                .foregroundStyle(.white.opacity(0.5))
                        }
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    Text(item.category)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                    
                    Text("•")
                        .foregroundStyle(.white.opacity(0.5))
                    
                    Text(formatTime(item.dateViewed))
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.5))
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: [FavoriteCocktail.self, CocktailHistory.self], inMemory: true)
}
