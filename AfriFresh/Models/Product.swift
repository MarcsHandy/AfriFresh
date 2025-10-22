import Foundation
import SwiftUI

// MARK: - Product Model
struct Product: Identifiable, Codable {
    var id: String = UUID().uuidString          // Unique ID for each product
    var name: String                            // Name of the product (e.g., Mango)
    var description: String                     // Short description
    var category: ProductCategory               // Category (Fruit, Vegetable, etc.)
    var price: Double                           // Price in UGX
    var images: [String]? = nil                 // Name of images in Assets.xcassets
    var imageURL: String?                       // URL of the image
    var farmerName: String                      // Farmer's name
    var inStock: Bool = true                    // Stock availability
    
    // Optional: Delivery time estimate
    var estimatedDeliveryDays: Int? = 1
}

// MARK: - Product Categories
enum ProductCategory: String, Codable, CaseIterable {
    case fruit = "Fruit"
    case vegetable = "Vegetable"
    case herb = "Herb"
    case other = "Other"
    
    var displayName: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .fruit: return "applelogo"
        case .vegetable: return "leaf"
        case .herb: return "flame"
        case .other: return "questionmark.circle"
        }
    }
}

// MARK: - Sample Preview Data
#if DEBUG
extension Product {
    static let sampleProducts: [Product] = [
        Product(name: "Mango", description: "Sweet and juicy Ugandan mango.", category: .fruit, price: 3000, images: ["mango"], farmerName: "John Okello"),
        Product(name: "Tomato", description: "Fresh farm tomatoes.", category: .vegetable, price: 1200, images: ["tomato"], farmerName: "Mary Nabwire"),
        Product(name: "Basil", description: "Organic fresh basil.", category: .herb, price: 800, images: ["basil"], farmerName: "Joseph Lule"),
        Product(name: "Carrot", description: "Crunchy and healthy carrots.", category: .vegetable, price: 1500, images: ["carrot"], farmerName: "Grace Achieng")
    ]
}
#endif

