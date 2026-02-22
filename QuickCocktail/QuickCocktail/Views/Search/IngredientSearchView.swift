import SwiftUI

struct IngredientSearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showResults = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    searchHeader
                    
                    if viewModel.hasSelectedIngredients {
                        selectedIngredientsSection
                    }
                    
                    if viewModel.isLoadingIngredients {
                        loadingView
                    } else if let error = viewModel.errorMessage {
                        errorView(message: error)
                    } else {
                        ingredientList
                    }
                }
            }
            .navigationTitle("Malzeme Seç")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
                
                ToolbarItem(placement: .primaryAction) {
                    if viewModel.hasSelectedIngredients {
                        Button("Temizle") {
                            viewModel.clearSelection()
                        }
                        .foregroundStyle(Color.accentColor)
                    }
                }
            }
            .sheet(isPresented: $showResults) {
                CocktailResultsView(
                    searchResults: viewModel.searchResults,
                    selectedIngredients: viewModel.selectedIngredients
                )
            }
        }
    }
    
    private var searchHeader: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.white.opacity(0.6))
                
                TextField("Malzeme ara...", text: $viewModel.searchText)
                    .textFieldStyle(.plain)
                    .foregroundStyle(.white)
                    .autocorrectionDisabled()
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
            .onChange(of: viewModel.searchText) { _, _ in
                viewModel.filterIngredients()
            }
            
            if viewModel.hasSelectedIngredients {
                Button(action: {
                    Task {
                        await viewModel.searchCocktails()
                        if !viewModel.searchResults.isEmpty {
                            showResults = true
                        }
                    }
                }) {
                    HStack {
                        if viewModel.isSearching {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "magnifyingglass")
                        }
                        
                        Text("Kokteyl Bul (\(viewModel.selectedIngredients.count) malzeme)")
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(viewModel.isSearching)
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
    
    private var selectedIngredientsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Seçilen Malzemeler")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.white.opacity(0.7))
                .padding(.horizontal)
            
            SelectedIngredientsView(
                ingredients: viewModel.selectedIngredients,
                onRemove: { ingredient in
                    viewModel.removeIngredient(ingredient)
                }
            )
        }
        .padding(.bottom, 8)
    }
    
    private var ingredientList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.filteredIngredients) { ingredient in
                    let isSelected = viewModel.selectedIngredients.contains { $0.id == ingredient.id }
                    
                    IngredientRow(
                        ingredient: ingredient,
                        isSelected: isSelected,
                        onTap: {
                            if isSelected {
                                viewModel.removeIngredient(SelectedIngredient(from: ingredient))
                            } else {
                                viewModel.selectIngredient(ingredient)
                            }
                        }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 100)
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)
            Text("Malzemeler yükleniyor...")
                .foregroundStyle(.white.opacity(0.8))
            Spacer()
        }
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
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
                    await viewModel.loadIngredients()
                }
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    IngredientSearchView()
}
