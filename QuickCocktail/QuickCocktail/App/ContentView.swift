import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home
        case favorites
        case history
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Ana Sayfa", systemImage: "house.fill")
                }
                .tag(Tab.home)
            
            FavoritesView()
                .tabItem {
                    Label("Favoriler", systemImage: "heart.fill")
                }
                .tag(Tab.favorites)
            
            HistoryView()
                .tabItem {
                    Label("Geçmiş", systemImage: "clock.fill")
                }
                .tag(Tab.history)
        }
        .tint(Color.accentColor)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [FavoriteCocktail.self, CocktailHistory.self, ShoppingListItem.self], inMemory: true)
}
