import SwiftUI

// MARK: - HomeView
struct HomeView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var cartViewModel: CartViewModel

    @State private var selectedCategory: String = "All"
    
    private let categories = ["All", "Fruits", "Vegetables"]
    
    private var filteredProducts: [Product] {
        if selectedCategory == "All" {
            return Constants.Mock.products
        } else {
            return Constants.Mock.products.filter { $0.category.displayName == selectedCategory }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // MARK: Categories Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                Text(category)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(
                                        selectedCategory == category
                                            ? settingsStore.currentTheme.accentColor
                                            : Color.gray.opacity(0.2)
                                    )
                                    .foregroundColor(selectedCategory == category ? .white : .primary)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
                
                // MARK: Products Grid
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(filteredProducts) { product in
                            NavigationLink(
                                destination: ProductDetailView(product: product)
                                    .environmentObject(cartViewModel)
                                    .environmentObject(settingsStore)
                            ) {
                                ProductCell(product: product)
                                    .environmentObject(cartViewModel)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("AfriFresh")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Preview
#Preview {
    let settingsStore = SettingsStore()
    let authViewModel = AuthViewModel()
    let cartVM = CartViewModel()
    
    HomeView()
        .environmentObject(settingsStore)
        .environmentObject(authViewModel)
        .environmentObject(cartVM)
}
