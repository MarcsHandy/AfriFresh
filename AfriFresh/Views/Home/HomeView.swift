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
                            VStack(spacing: 8) {
                                NavigationLink(
                                    destination: ProductDetailView(product: product)
                                        .environmentObject(cartViewModel)
                                        .environmentObject(settingsStore)
                                ) {
                                    ProductCell(product: product)
                                        .environmentObject(cartViewModel)
                                }
                                
                                // Only show plus/minus if product is in cart
                                if let cartItem = cartViewModel.items.first(where: { $0.product.id == product.id }) {
                                    HStack(spacing: 12) {
                                        // Minus button
                                        Button(action: {
                                            let newQuantity = max(cartItem.quantity - 1, 0)
                                            cartViewModel.updateQuantity(for: cartItem, quantity: newQuantity)
                                        }) {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(cartItem.quantity > 0 ? .red : .gray)
                                                .font(.title2)
                                        }
                                        
                                        // Quantity label
                                        Text("\(cartItem.quantity)")
                                            .font(.headline)
                                            .frame(minWidth: 24)
                                        
                                        // Plus button
                                        Button(action: {
                                            cartViewModel.updateQuantity(for: cartItem, quantity: cartItem.quantity + 1)
                                        }) {
                                            Image(systemName: "plus.circle.fill")
                                                .foregroundColor(.green)
                                                .font(.title2)
                                        }
                                    }
                                    .padding(.top, 4)
                                } else {
                                    // Cart icon: first tap adds 1 to cart
                                    Button(action: {
                                        cartViewModel.addToCart(product)
                                    }) {
                                        Image(systemName: "cart.badge.plus")
                                            .foregroundColor(.blue)
                                            .font(.title2)
                                    }
                                    .padding(.top, 4)
                                }
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
