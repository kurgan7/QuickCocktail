import SwiftUI
import SwiftData

@main
struct QuickCocktailApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FavoriteCocktail.self,
            CocktailHistory.self,
            ShoppingListItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(sharedModelContainer)
    }
}

struct RootView: View {
    @State private var showLaunchScreen = true
    
    var body: some View {
        ZStack {
            ContentView()
                .opacity(showLaunchScreen ? 0 : 1)
            
            if showLaunchScreen {
                LaunchScreenView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showLaunchScreen = false
                }
            }
        }
    }
}
