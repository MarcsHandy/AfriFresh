import Foundation
import Combine

// MARK: - Cart ViewModel
class CartViewModel: ObservableObject {
    @Published private(set) var items: [CartItem] = []
    @Published var checkoutMessage: String? = nil
    
    private var removalTimers: [UUID: Timer] = [:] // Track timers for delayed removal
    
    // MARK: - Add Item
    func addToCart(_ product: Product) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
            cancelRemovalTimer(for: items[index])
        } else {
            let newItem = CartItem(product: product, quantity: 1)
            items.append(newItem)
        }
    }
    
    // MARK: - Remove Item Immediately
    func removeFromCart(_ product: Product) {
        guard let index = items.firstIndex(where: { $0.product.id == product.id }) else { return }
        if items[index].quantity > 1 {
            items[index].quantity -= 1
            scheduleRemovalIfNeeded(for: items[index])
        } else {
            items.remove(at: index)
        }
    }
    
    // MARK: - Update Quantity with delayed removal
    func updateQuantity(for item: CartItem, quantity: Int) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].quantity = quantity
        
        if quantity == 0 {
            // Schedule removal after 3 seconds
            scheduleRemovalIfNeeded(for: items[index])
        } else {
            // Cancel any pending removal if quantity increased
            cancelRemovalTimer(for: items[index])
        }
    }
    
    // MARK: - Get current quantity for a product
    func quantity(for product: Product) -> Int {
        items.first(where: { $0.product.id == product.id })?.quantity ?? 0
    }
    
    // MARK: - Delayed removal helpers
    private func scheduleRemovalIfNeeded(for item: CartItem) {
        removalTimers[item.id]?.invalidate()
        removalTimers[item.id] = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.items.removeAll { $0.id == item.id }
            self.removalTimers[item.id] = nil
        }
    }
    
    private func cancelRemovalTimer(for item: CartItem) {
        removalTimers[item.id]?.invalidate()
        removalTimers[item.id] = nil
    }
    
    // MARK: - Set items for previews or initialization
    func setItems(_ newItems: [CartItem]) {
        items = newItems
    }
    
    // MARK: - Remove by IndexSet (for .onDelete)
    func removeItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
    // MARK: - Remove Entire Product
    func removeAllOfProduct(_ product: Product) {
        items.removeAll { $0.product.id == product.id }
    }
    
    // MARK: - Calculate Total
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    // MARK: - Clear Cart
    func clearCart() {
        items.removeAll()
        checkoutMessage = nil
        removalTimers.values.forEach { $0.invalidate() }
        removalTimers.removeAll()
    }
    
    // MARK: - Checkout Simulation
    func checkout(orderViewModel: OrderViewModel, userId: String = "current_user_id", completion: @escaping (Bool) -> Void) {
        // 🧾 Check if cart is empty
        guard !items.isEmpty else {
            checkoutMessage = "Your cart is empty."
            completion(false)
            return
        }
        
        // 🛑 Prevent checkout if any item has quantity 0
        guard items.allSatisfy({ $0.quantity > 0 }) else {
            checkoutMessage = "Remove or update items with 0 quantity before checkout."
            completion(false)
            return
        }

        // ✅ Create order items
        let orderItems = items.map {
            OrderItem(
                productId: $0.product.id,
                name: $0.product.name,
                quantity: $0.quantity,
                price: $0.product.price
            )
        }

        // ✅ Create new order
        let newOrder = Order(
            userId: userId,
            items: orderItems,
            status: .pending,
            createdAt: Date()
        )

        // ✅ Add order to OrderViewModel
        orderViewModel.recentOrders.append(newOrder)

        // 💬 Simulate confirmation delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.checkoutMessage = "✅ Order placed successfully!"
            self.clearCart()
            completion(true)
        }
    }
}
