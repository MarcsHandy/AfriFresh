import Foundation
import SwiftUI

struct Farmer: Identifiable, Codable {
    var id: String = UUID().uuidString       // Unique ID for each farmer
    var name: String                          // Farmer's name
    var farmName: String?                     // Optional farm name
    var location: String                       // City or district
    var profileImageURL: String?              // Optional URL to profile image
    var rating: Double = 0.0                  // Average rating (0-5)
    var contactNumber: String?                // Optional phone number
    var bio: String?                          // Optional short bio or description
    
    // Example computed property for display
    var displayName: String {
        farmName != nil ? "\(name) (\(farmName!))" : name
    }
    
    // Example: Initialize from Firebase dictionary
    init(from dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? UUID().uuidString
        self.name = dictionary["name"] as? String ?? "Unknown Farmer"
        self.farmName = dictionary["farmName"] as? String
        self.location = dictionary["location"] as? String ?? "Unknown Location"
        self.profileImageURL = dictionary["profileImageURL"] as? String
        self.rating = dictionary["rating"] as? Double ?? 0.0
        self.contactNumber = dictionary["contactNumber"] as? String
        self.bio = dictionary["bio"] as? String
    }
    
    // Default initializer
    init(id: String = UUID().uuidString,
         name: String,
         farmName: String? = nil,
         location: String,
         profileImageURL: String? = nil,
         rating: Double = 0.0,
         contactNumber: String? = nil,
         bio: String? = nil) {
        self.id = id
        self.name = name
        self.farmName = farmName
        self.location = location
        self.profileImageURL = profileImageURL
        self.rating = rating
        self.contactNumber = contactNumber
        self.bio = bio
    }
}

// MARK: - Sample Preview Data
extension Farmer {
    static let sampleFarmers: [Farmer] = [
        Farmer(name: "Kato", farmName: "Kato's Farm", location: "Kampala", profileImageURL: nil, rating: 4.5),
        Farmer(name: "Nansubuga", farmName: "Fresh Harvest", location: "Jinja", profileImageURL: nil, rating: 4.8),
        Farmer(name: "Okello", farmName: "Okello Veggies", location: "Gulu", profileImageURL: nil, rating: 4.2)
    ]
}


