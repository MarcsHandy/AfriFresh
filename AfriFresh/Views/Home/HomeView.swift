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
                                    .background(selectedCategory == category ? settingsStore.currentTheme.accentColor : Color.gray.opacity(0.2))
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
                            VStack {
                                // Navigation link for tapping the whole cell
                                NavigationLink(
                                    destination: ProductDetailView(product: product)
                                        .environmentObject(cartViewModel)
                                        .environmentObject(settingsStore)
                                ) {
                                    ProductCell(product: product)
                                }
                                
                                // Inline + / − controls for adding/removing from cart directly
                                HStack(spacing: 12) {
                                    Button(action: {
                                        if let currentQuantity = cartViewModel.items.first(where: { $0.product.id == product.id })?.quantity, currentQuantity > 0 {
                                            cartViewModel.updateQuantity(for: CartItem(product: product, quantity: 1), quantity: currentQuantity - 1)
                                        }
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(cartViewModel.items.first(where: { $0.product.id == product.id })?.quantity ?? 0 > 0 ? .red : .gray)
                                            .font(.title2)
                                    }
                                    
                                    Text("\(cartViewModel.items.first(where: { $0.product.id == product.id })?.quantity ?? 0)")
                                        .font(.headline)
                                        .frame(minWidth: 24)
                                    
                                    Button(action: {
                                        cartViewModel.addToCart(product)
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(.green)
                                            .font(.title2)
                                    }
                                }
                                .padding(.top, 4)
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
