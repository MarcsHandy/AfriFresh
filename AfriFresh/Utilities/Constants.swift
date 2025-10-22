import SwiftUI

struct Constants {
    
    // MARK: - App Info
    static let appName = "AfriFresh"
    static let tagline = "Local Food. Fresh from Farmers."
    static let version = "1.0.0"
    
    // MARK: - API Endpoints (placeholder)
    struct API {
        static let baseURL = "https://api.afrifresh.ug" // Example base URL
        static let products = "\(baseURL)/products"
        static let farmers = "\(baseURL)/farmers"
        static let orders = "\(baseURL)/orders"
        static let auth = "\(baseURL)/auth"
    }
    
    // MARK: - Payment
    struct Payment {
        static let supportedMethods = ["MTN Mobile Money", "Airtel Money"]
        static let mtnUSSD = "*165#"
        static let airtelUSSD = "*185#"
    }
    
    // MARK: - Theme
    struct Theme {
        static let primaryColor = Color("PrimaryColor") // Define in Assets
        static let secondaryColor = Color("SecondaryColor")
        static let accentColor = Color.green
        static let backgroundColor = Color(.systemBackground)
        static let textColor = Color.primary
        static let lightGray = Color.gray.opacity(0.2)
    }
    
    // MARK: - Images
    struct Images {
        static let appLogo = "afrifresh_logo"
        static let placeholder = "produce_placeholder"
        static let banner = "farm_banner"
    }
    
    // MARK: - Mock Data (for MVP demo)
    struct Mock {
        static let products: [Product] = [
            Product(
                name: "Fresh Bananas",
                description: "Sweet ripe bananas from local farmers",
                category: .fruit,
                price: 2500,
                images: ["bananas"],          
                farmerName: "Farmer John"
            ),
            Product(
                name: "Organic Tomatoes",
                description: "Juicy organic tomatoes",
                category: .vegetable,
                price: 3000,
                images: ["tomatoes"],
                farmerName: "Farmer Mary"
            ),
            Product(
                name: "Matooke (Green Bananas)",
                description: "Traditional Ugandan green bananas",
                category: .fruit,
                price: 1800,
                images: ["matooke"],
                farmerName: "Farmer David"
            ),
            Product(
                name: "Sweet Potatoes",
                description: "Organic sweet potatoes",
                category: .vegetable,
                price: 2200,
                images: ["sweet_potatoes"],
                farmerName: "Farmer Alice"
            ),
            Product(
                name: "Fresh Mangoes",
                description: "Delicious ripe mangoes",
                category: .fruit,
                price: 3500,
                images: ["mangoes"],
                farmerName: "Farmer Sam"
            )
        ]
    }

    // MARK: - Developer Info
    struct Developer {
        static let author = "Marcos Butler-Torres"
        static let email = "support@afrifresh.ug"
        static let website = "https://afrifresh.ug"
    }
}

