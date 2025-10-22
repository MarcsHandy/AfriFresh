import Foundation

// MARK: - Order Status Enum
enum OrderStatus: String, Codable, CaseIterable {
    case pending = "Pending"
    case confirmed = "Confirmed"
    case outForDelivery = "Out for Delivery"
    case delivered = "Delivered"
    case cancelled = "Cancelled"
}

// MARK: - Order Item Model
struct OrderItem: Identifiable, Codable {
    var id: String = UUID().uuidString
    var productId: String
    var name: String
    var quantity: Int
    var price: Double
    
    // Computed property for total price of the item
    var total: Double {
        return Double(quantity) * price
    }
    
    // Full initializer with default id
    init(id: String = UUID().uuidString,
         productId: String,
         name: String,
         quantity: Int,
         price: Double) {
        self.id = id
        self.productId = productId
        self.name = name
        self.quantity = quantity
        self.price = price
    }
}

// MARK: - Order Model
struct Order: Identifiable, Codable {
    var id: String = UUID().uuidString
    var userId: String
    var items: [OrderItem]
    
    // Computed property for total amount of the order
    var totalAmount: Double {
        items.reduce(0) { $0 + $1.total }
    }
    
    var status: OrderStatus = .pending
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    // Optional delivery info
    var deliveryAddress: String?
    var estimatedDeliveryTime: Date?
    
    // Full initializer with defaults
    init(
        id: String = UUID().uuidString,
        userId: String,
        items: [OrderItem],
        status: OrderStatus = .pending,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        deliveryAddress: String? = nil,
        estimatedDeliveryTime: Date? = nil
    ) {
        self.id = id
        self.userId = userId
        self.items = items
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deliveryAddress = deliveryAddress
        self.estimatedDeliveryTime = estimatedDeliveryTime
    }
}
