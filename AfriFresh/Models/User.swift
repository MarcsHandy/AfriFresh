import Foundation
import FirebaseFirestore

// MARK: - User Model
struct User: Identifiable, Codable {
    @DocumentID var id: String?           // Firebase document ID
    var fullName: String                  // User's full name
    var email: String                     // Email address
    var phoneNumber: String?              // Optional phone number
    var address: String?                  // Delivery address
    var createdAt: Date?                  // Account creation date
    
    // Optional: List of past order IDs
    var orderIDs: [String]?
    
    // Default initializer
    init(id: String? = nil,
         fullName: String,
         email: String,
         phoneNumber: String? = nil,
         address: String? = nil,
         createdAt: Date? = Date(),
         orderIDs: [String]? = []) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.phoneNumber = phoneNumber
        self.address = address
        self.createdAt = createdAt
        self.orderIDs = orderIDs
    }
}

// MARK: - Sample Preview Data (for SwiftUI Previews)
#if DEBUG
extension User {
    static let sample = User(
        id: "12345",
        fullName: "Jane Doe",
        email: "jane@example.com",
        phoneNumber: "+256700000000",
        address: "Kampala, Uganda",
        createdAt: Date(),
        orderIDs: ["order1", "order2"]
    )
}
#endif

