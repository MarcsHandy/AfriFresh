import Foundation
import Combine

// MARK: - Cart ViewModel
class CartViewModel: ObservableObject {
    @Published private(set) var items: [CartItem] = []
    @Published var checkoutMessage: String? = nil
    
    // MARK: - Add Item
    func addToCart(_ product: Product) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            let newItem = CartItem(product: product, quantity: 1)
            items.append(newItem)
        }
    }
    
    // MARK: - Remove Item
    func removeFromCart(_ product: Product) {
        guard let index = items.firstIndex(where: { $0.product.id == product.id }) else { return }
        if items[index].quantity > 1 {
            items[index].quantity -= 1
        } else {
            items.remove(at: index)
        }
    }
    
    //MARK: - Quantity Updater
    func updateQuantity(for item: CartItem, quantity: Int) {
            guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
            items[index].quantity = quantity
    }
    
    //MARK: - Add a method to set items for previews or initialization
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
    }
    
    // MARK: - Checkout Simulation
    func checkout(orderViewModel: OrderViewModel, userId: String = "current_user_id", completion: @escaping (Bool) -> Void) {
        guard !items.isEmpty else {
            checkoutMessage = "Your cart is empty."
            completion(false)
            return
        }

        // Create order items
        let orderItems = items.map {
            OrderItem(
                productId: $0.product.id,
                name: $0.product.name,
                quantity: $0.quantity,
                price: $0.product.price
            )
        }

        // Create an order
        let newOrder = Order(
            userId: userId,
            items: orderItems,
            status: .pending,
            createdAt: Date()
        )

        // Add to OrderViewModel
        orderViewModel.recentOrders.append(newOrder)

        // Simulate delay for user feedback
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.checkoutMessage = "✅ Order placed successfully!"
            self.clearCart()
            completion(true)
        }
    }
}

