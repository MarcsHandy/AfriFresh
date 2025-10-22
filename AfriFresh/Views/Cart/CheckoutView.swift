import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var settingsStore: SettingsStore
    
    @State private var selectedPaymentMethod: PaymentMethod = .mtn
    @State private var isProcessing: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    enum PaymentMethod: String, CaseIterable, Identifiable {
        case mtn = "MTN Mobile Money"
        case airtel = "Airtel Money"
        case card = "Card"
        
        var id: String { rawValue }
    }
    
    var body: some View {
        VStack {
            Text("Checkout")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            List {
                Section(header: Text("Your Items")) {
                    ForEach(cartViewModel.items) { item in
                        HStack {
                            Text(item.product.name)
                            Spacer()
                            Text("UGX \(item.product.price * Double(item.quantity), specifier: "%.0f")")
                        }
                    }
                }

                
                Section(header: Text("Payment Method")) {
                    Picker("Payment Method", selection: $selectedPaymentMethod) {
                        ForEach(PaymentMethod.allCases) { method in
                            Text(method.rawValue).tag(method)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Total")) {
                    HStack {
                        Spacer()
                        Text("UGX \(cartViewModel.totalPrice, specifier: "%.0f")") // <-- remove ()
                            .font(.headline)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            
            Spacer()
            
            Button(action: {
                processCheckout()
            }) {
                HStack {
                    if isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                    Text(isProcessing ? "Processing..." : "Confirm Payment")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(settingsStore.currentTheme.accentColor)
                        .cornerRadius(10)
                }
            }
            .padding()
            .disabled(isProcessing || cartViewModel.items.isEmpty)
            
        }
        .navigationTitle("Checkout")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Checkout"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func processCheckout() {
        guard !cartViewModel.items.isEmpty else {
            alertMessage = "Your cart is empty."
            showAlert = true
            return
        }
        
        isProcessing = true
        
        // Simulate payment processing delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isProcessing = false
            
            // Here you would call PaymentService + OrderViewModel to create the order
            cartViewModel.clearCart()
            
            alertMessage = "Payment successful! Your order has been placed."
            showAlert = true
        }
    }
}

// MARK: - Preview

#Preview {
    let cartVM = CartViewModel()
    let settingsStore = SettingsStore()
    let authVM = AuthViewModel()
    
    // Mock product with multi-image support
    let sampleProduct = Product(
        id: "1",
        name: "Tomatoes",
        description: "Fresh farm tomatoes from Uganda.",
        category: .vegetable,
        price: 5000,
        images: ["tomato"],             
        farmerName: "Mary Nabwire"
    )
    
    // Populate cart
    cartVM.setItems([CartItem(product: sampleProduct, quantity: 2)])
    
    // Return the view
    return NavigationStack {
        CheckoutView()
            .environmentObject(cartVM)
            .environmentObject(settingsStore)
            .environmentObject(authVM)
    }
}




