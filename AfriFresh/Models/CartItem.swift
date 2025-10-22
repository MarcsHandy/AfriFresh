import Foundation

struct CartItem: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int
    
    var totalPrice: Double {
        return Double(quantity) * product.price
    }
}
