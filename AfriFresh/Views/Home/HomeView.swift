import SwiftUI

// MARK: - HomeView
struct HomeView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var cartViewModel: CartViewModel

    @State private var selectedCategory: String = "All"
    @State private var showingCartControls: [String: Bool] = [:] // Track plus/minus visibility per product
    @State private var searchText: String = "" // 🔍 Search bar text
    @State private var selectedAddress: String = "No delivery address set" // 🏠 current address
    
    private let categories = ["All", "Fruits", "Vegetables"]
    
    // MARK: Filter Logic (Category + Search)
    private var filteredProducts: [Product] {
        let baseList: [Product]
        if selectedCategory == "All" {
            baseList = Constants.Mock.products
        } else {
            baseList = Constants.Mock.products.filter { $0.category.displayName == selectedCategory }
        }
        
        if searchText.isEmpty {
            return baseList
        } else {
            return baseList.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                
                // MARK: 🏠 Delivery Location Button
                NavigationLink(destination: ChooseDeliveryLocationView(selectedAddress: $selectedAddress)) {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Delivering to:")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                            Text(selectedAddress)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.85))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }

                // MARK: Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search for food...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
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
                }
                
                // MARK: Products Grid
                ScrollView {
                    if filteredProducts.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass.circle")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray)
                            Text("No results found")
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 100)
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(filteredProducts) { product in
                                VStack(spacing: 8) {
                                    NavigationLink(
                                        destination: ProductDetailView(product: product)
                                            .environmentObject(cartViewModel)
                                            .environmentObject(settingsStore)
                                    ) {
                                        ProductCell(product: product)
                                    }
                                    
                                    let cartItem = cartViewModel.items.first(where: { $0.product.id == product.id })
                                    let isShowingControls = showingCartControls[product.id] ?? (cartItem != nil)
                                    
                                    if isShowingControls, let item = cartItem {
                                        HStack(spacing: 12) {
                                            // Minus button
                                            Button(action: {
                                                let newQuantity = max(item.quantity - 1, 0)
                                                cartViewModel.updateQuantity(for: item, quantity: newQuantity)
                                                
                                                if newQuantity == 0 {
                                                    // Revert to cart icon after 3 seconds
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                        showingCartControls[product.id] = false
                                                    }
                                                }
                                            }) {
                                                Image(systemName: "minus.circle.fill")
                                                    .foregroundColor(item.quantity > 0 ? .red : .gray)
                                                    .font(.title2)
                                            }
                                            
                                            // Quantity label
                                            Text("\(item.quantity)")
                                                .font(.headline)
                                                .frame(minWidth: 24)
                                            
                                            // Plus button
                                            Button(action: {
                                                cartViewModel.updateQuantity(for: item, quantity: item.quantity + 1)
                                            }) {
                                                Image(systemName: "plus.circle.fill")
                                                    .foregroundColor(.green)
                                                    .font(.title2)
                                            }
                                        }
                                        .padding(.top, 4)
                                    } else {
                                        // Cart icon
                                        Button(action: {
                                            cartViewModel.addToCart(product)
                                            showingCartControls[product.id] = true
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
