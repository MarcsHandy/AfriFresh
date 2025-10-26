import SwiftUI
import MapKit
import CoreLocation

struct StoresNearbyView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.3476, longitude: 32.5825), // Kampala (fallback)
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    let stores = [
        Store(name: "FreshMart - Ntinda", latitude: 0.3498, longitude: 32.6150),
        Store(name: "Green Basket - Kololo", latitude: 0.3339, longitude: 32.5883),
        Store(name: "Organic Hub - Bugolobi", latitude: 0.3075, longitude: 32.6332),
        Store(name: "Kisaasi Market", latitude: 0.3721, longitude: 32.6038)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Stores Near You")
                .font(.headline)
                .padding(.horizontal)
            
            ZStack(alignment: .bottomTrailing) {
                // MARK: Interactive Map
                Map(coordinateRegion: $region,
                    showsUserLocation: true,
                    annotationItems: stores) { store in
                    MapMarker(coordinate: store.coordinate, tint: .green)
                }
                .frame(height: 250)
                .cornerRadius(12)
                .padding(.horizontal)
                .gesture(DragGesture()) // enables dragging manually
                .gesture(MagnificationGesture()) // enables pinch-to-zoom
                .onReceive(locationManager.$userLocation) { newLocation in
                    if let newLocation = newLocation {
                        region.center = newLocation
                    }
                }
            
                // MARK: Zoom Buttons
                VStack(spacing: 10) {
                    Button(action: {
                        withAnimation {
                            zoomIn()
                        }
                    }) {
                        Image(systemName: "plus.magnifyingglass")
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        withAnimation {
                            zoomOut()
                        }
                    }) {
                        Image(systemName: "minus.magnifyingglass")
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                    }
                    
                    // MARK: Current Location Button
                    Button(action: {
                        withAnimation {
                            centerOnUserLocation()
                        }
                    }) {
                        Image(systemName: "location.fill")
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(stores) { store in
                        VStack(alignment: .leading) {
                            Text(store.name)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("Open • Pickup Available")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 10)
        }
    }
    
    // MARK: - Location Methods
    private func setupLocation() {
        if let userLocation = locationManager.userLocation {
            region.center = userLocation
        }
    }
    
    private func centerOnUserLocation() {
        if let userLocation = locationManager.userLocation {
            region.center = userLocation
        }
    }
    
    // MARK: - Zoom Helper Methods
    private func zoomIn() {
        region.span.latitudeDelta /= 1.5
        region.span.longitudeDelta /= 1.5
    }
    
    private func zoomOut() {
        region.span.latitudeDelta *= 1.5
        region.span.longitudeDelta *= 1.5
    }
}

struct Store: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

#Preview {
    StoresNearbyView()
}
