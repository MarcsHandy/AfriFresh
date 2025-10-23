import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var settingsStore: SettingsStore
    @EnvironmentObject var orderViewModel: OrderViewModel
    
    @State private var showCheckoutAlert = false
    @State private var checkoutMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if cartViewModel.items.isEmpty {
                    // 🛒 Empty cart state
                    VStack(spacing: 16) {
                        Image(systemName: "cart")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                        Text("Your cart is empty")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // 🧺 Cart items list
                    List {
                        ForEach(cartViewModel.items) { item in
                            HStack {
                                Text(item.product.name)
                                    .font(.headline)
                                Spacer()
                                
                                // Stepper for quantity
                                Stepper(value: Binding(
                                    get: { item.quantity },
                                    set: { newQuantity in
                                        cartViewModel.updateQuantity(for: item, quantity: newQuantity)
                                    }
                                ), in: 0...100) {
                                    Text("Qty: \(item.quantity)")
                                        .frame(minWidth: 50)
                                }
                                
                                Text("UGX \(item.totalPrice, specifier: "%.0f")")
                            }
                        }
                        .onDelete(perform: cartViewModel.removeItem)
                    }
                    
                    // 💰 Total + Checkout
                    VStack(spacing: 16) {
                        HStack {
                            Text("Total")
                                .font(.headline)
                            Spacer()
                            Text("UGX \(cartViewModel.totalPrice, specifier: "%.0f")")
                                .font(.headline)
                        }
                        .padding(.horizontal)
                        
                        Button(action: {
                            cartViewModel.checkout(orderViewModel: orderViewModel) { success in
                                checkoutMessage = cartViewModel.checkoutMessage ?? (success ? "Order placed successfully!" : "Failed to checkout.")
                                showCheckoutAlert = true
                            }
                        }) {
                            Text("Checkout")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(settingsStore.currentTheme.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("My Cart")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showCheckoutAlert) {
                Alert(
                    title: Text("Checkout"),
                    message: Text(checkoutMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        // Observe cart items and update UI when an item disappears after 3 seconds
        .onReceive(cartViewModel.$items) { _ in
            // Force view update when items change (needed for delayed removal)
        }
    }
}

// MARK: - Preview
#Preview {
    let settings = SettingsStore()
    let cartVM = CartViewModel()
    let orderVM = OrderViewModel.preview
    
    let sampleProduct = Product(
        id: "1",
        name: "Tomatoes",
        description: "Fresh tomatoes",
        category: .vegetable,
        price: 1800,
        images: ["tomatoes"],
        farmerName: "Farmer Mary"
    )
    
    cartVM.addToCart(sampleProduct)
    
    return CartView()
        .environmentObject(cartVM)
        .environmentObject(orderVM)
        .environmentObject(settings)
}
