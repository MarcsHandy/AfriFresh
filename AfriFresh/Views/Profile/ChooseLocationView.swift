import SwiftUI
import MapKit

struct ChooseDeliveryLocationView: View {
    @Binding var selectedAddress: String
    @StateObject private var locationManager = LocationManager()
    @State private var chosenAddress: SavedAddress?
    @State private var showSavedAddresses = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Choose Delivery Location")
                .font(.headline)
            
            // 🗺️ Map with user location
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: locationManager.userLocation ?? CLLocationCoordinate2D(latitude: 0.3476, longitude: 32.5825),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )), showsUserLocation: true)
            .frame(height: 250)
            .cornerRadius(12)
            .padding(.horizontal)
            
            // 📍 Use Current Location
            Button("Use My Current Location") {
                if let loc = locationManager.userLocation {
                    // Update local address
                    chosenAddress = SavedAddress(
                        label: "Current Location",
                        address: "Live GPS",
                        latitude: loc.latitude,
                        longitude: loc.longitude
                    )
                    
                    // Update parent view’s address
                    selectedAddress = "Live GPS (Lat: \(loc.latitude), Lon: \(loc.longitude))"
                }
            }
            .buttonStyle(.borderedProminent)
            
            // 📦 Saved Addresses
            Button("Choose From Saved Addresses") {
                showSavedAddresses.toggle()
            }
            .sheet(isPresented: $showSavedAddresses) {
                SavedAddressesView(onSelect: { address in
                    chosenAddress = address
                    selectedAddress = address.label
                    showSavedAddresses = false
                })
            }
            
            // ✅ Show Selected Address
            if let addr = chosenAddress {
                VStack(alignment: .leading) {
                    Text("Selected:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(addr.label)
                        .font(.headline)
                    Text(addr.address)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            locationManager.requestLocation()
        }
    }
}
