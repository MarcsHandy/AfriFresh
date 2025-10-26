import Foundation
import FirebaseFirestore
import CoreLocation

// MARK: - User Model
struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var fullName: String
    var email: String
    var phoneNumber: String?
    var address: String? // Default or current address
    var createdAt: Date?
    var orderIDs: [String]?
    
    // ✅ New: list of saved addresses
    var savedAddresses: [SavedAddress]?
    
    init(id: String? = nil,
         fullName: String,
         email: String,
         phoneNumber: String? = nil,
         address: String? = nil,
         createdAt: Date? = Date(),
         orderIDs: [String]? = [],
         savedAddresses: [SavedAddress]? = []) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.phoneNumber = phoneNumber
        self.address = address
        self.createdAt = createdAt
        self.orderIDs = orderIDs
        self.savedAddresses = savedAddresses
    }
}
