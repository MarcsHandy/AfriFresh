import Foundation
import CoreLocation

struct SavedAddress: Identifiable, Codable {
    var id = UUID()
    var label: String
    var address: String
    var latitude: Double
    var longitude: Double
}
