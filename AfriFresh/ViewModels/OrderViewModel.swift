import Foundation
import Combine

// MARK: - OrderViewModel
class OrderViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var cartItems: [Product] = []
    @Published var recentOrders: [Order] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var orderPlaced = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadMockProducts()
    }
    
    // MARK: - Load Mock Data
    func loadMockProducts() {
        products = [
            Product(
                name: "Matoke (Bananas)",
                description: "Fresh green bananas from local farms.",
                category: .fruit,
                price: 2500,
                images: ["bananas"],
                farmerName: "Farmer John",
                inStock: true
            ),
            Product(
                name: "Tomatoes",
                description: "Juicy organic tomatoes.",
                category: .vegetable,
                price: 1800,
                images: ["tomatoes"],
                farmerName: "Farmer Mary",
                inStock: true
            ),
            Product(
                name: "Pineapple",
                description: "Sweet tropical pineapple.",
                category: .fruit,
                price: 3000,
                images: ["pineapple"],
                farmerName: "Farmer Joseph",
                inStock: true
            ),
            Product(
                name: "Cassava",
                description: "Fresh root cassava.",
                category: .other,
                price: 2200,
                images: ["cassava"],
                farmerName: "Farmer Grace",
                inStock: true
            ),
            Product(
                name: "Sweet Potatoes",
                description: "Organic sweet potatoes.",
                category: .other,
                price: 2500,
                images: ["sweetpotatoes"],
                farmerName: "Farmer Alice",
                inStock: true
            ),
            Product(
                name: "Avocados",
                description: "Ripe avocados, perfect for smoothies.",
                category: .fruit,
                price: 2000,
                images: ["avocado"],
                farmerName: "Farmer Sam",
                inStock: false
            )
        ]
    }
        
    // MARK: - Cart Management
    func addToCart(_ product: Product) {
        guard product.inStock else {
            errorMessage = "\(product.name) is currently unavailable."
            return
        }
        cartItems.append(product)
    }
    
    func removeFromCart(_ product: Product) {
        cartItems.removeAll { $0.id == product.id }
    }
    
    func clearCart() {
        cartItems.removeAll()
    }
    
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + $1.price }
    }
    
    func fetchOrders(for userId: String) {
        isLoading = true
        errorMessage = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Only filter orders that match this user
            // If none exist yet, keep existing for local testing
            let userOrders = self.recentOrders.filter { $0.userId == userId }
            if !userOrders.isEmpty {
                self.recentOrders = userOrders
            }
            self.isLoading = false
        }
    }

    // MARK: - Place Order
    func placeOrder(for userId: String?, paymentMethod: String = "MTN Mobile Money") {
        guard !cartItems.isEmpty else {
            errorMessage = "Your cart is empty."
            return
        }

        isLoading = true
        orderPlaced = false
        errorMessage = nil

        // Simulate network delay
        let deadlineTime = DispatchTime.now() + 2.0
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            let orderItems = self.cartItems.map { product in
                OrderItem(
                    productId: product.id,
                    name: product.name,
                    quantity: 1,
                    price: product.price
                )
            }

            // Use real user ID if available, fallback to guest_user
            let currentUserId = userId ?? "guest_user"

            let newOrder = Order(
                userId: currentUserId,
                items: orderItems,
                status: .pending,
                deliveryAddress: nil
            )

            self.recentOrders.append(newOrder)
            self.clearCart()
            self.isLoading = false
            self.orderPlaced = true

            print("✅ Order placed successfully via \(paymentMethod) for user: \(currentUserId)")
        })
    }

    // MARK: - Payment Simulation
    func processMobileMoneyPayment(network: String, amount: Double) {
        // Simulated MTN/Airtel payment logic
        print("💰 Processing \(network) Mobile Money payment of \(amount) UGX...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            print("✅ \(network) Payment Successful!")
        }
    }
    
    // MARK: - Preview / Mock ViewModel
    static var preview: OrderViewModel {
        let vm = OrderViewModel()
        
        // Add mock products
        let product1 = Product(
            id: "prod_001",
            name: "Tomatoes",
            description: "Fresh tomatoes",
            category: .vegetable,
            price: 1800,
            images: ["tomatoes"],
            farmerName: "Farmer Mary",
            inStock: true
        )
        
        let product2 = Product(
            id: "prod_002",
            name: "Bananas",
            description: "Ripe bananas",
            category: .fruit,
            price: 2000,
            images: ["banana"],
            farmerName: "Farmer John",
            inStock: true
        )
        
        // Add to cartItems to preview cart
        vm.cartItems = [product1, product2]
        
        // Add recent orders
        let orderItem1 = OrderItem(productId: product1.id, name: product1.name, quantity: 3, price: product1.price)
        let orderItem2 = OrderItem(productId: product2.id, name: product2.name, quantity: 5, price: product2.price)
        
        let order = Order(
            id: "order_001",
            userId: "user_001",
            items: [orderItem1, orderItem2],
            status: .outForDelivery
        )
        
        vm.recentOrders = [order]
        
        return vm
    }
}

