import SwiftUI

struct ContentView: View {
    @StateObject private var settingsStore = SettingsStore()
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var orderViewModel = OrderViewModel()

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                AppNavigationView()
                    .environmentObject(settingsStore)
                    .environmentObject(authViewModel)
                    .environmentObject(cartViewModel)
                    .environmentObject(orderViewModel)
            } else {
                LoginView(authViewModel: authViewModel)
                    .environmentObject(settingsStore)
            }
        }
        .onAppear {
            print("📱 App appeared - Authenticated: \(authViewModel.isAuthenticated)")
        }
    }
}

// MARK: - Preview
#Preview {
    let settingsStore = SettingsStore()
    let authViewModel = AuthViewModel()
    let cartVM = CartViewModel()
    let orderVM = OrderViewModel()
    
    // dummy product for cart preview
    let sampleProduct = Product(
        id: "1",
        name: "Tomatoes",
        description: "Fresh farm tomatoes",
        category: .vegetable,
        price: 1200,
        images: ["tomato"],
        farmerName: "Mary Nabwire"
    )
    cartVM.setItems([CartItem(product: sampleProduct, quantity: 2)])
    
    return ContentView()
        .environmentObject(settingsStore)
        .environmentObject(authViewModel)
        .environmentObject(cartVM)
        .environmentObject(orderVM)
}
