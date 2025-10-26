import SwiftUI

struct SavedAddressesView: View {
    @AppStorage("savedAddresses") private var savedAddressesData: Data = Data()
    @State private var savedAddresses: [SavedAddress] = []
    @State private var newLabel = ""
    @State private var newAddress = ""
    
    // ✅ Callback to return selected address
    var onSelect: ((SavedAddress) -> Void)?
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Saved Delivery Addresses")
                .font(.headline)
                .padding(.top)
            
            // 📍 List of Saved Addresses
            List {
                ForEach(savedAddresses) { addr in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(addr.label)
                                .font(.headline)
                            Text(addr.address)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        
                        // ✅ Select button
                        Button(action: {
                            onSelect?(addr)
                        }) {
                            Text("Select")
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.85))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
                .onDelete(perform: deleteAddress)
            }
            
            // 🏠 Add New Address Section
            VStack(spacing: 8) {
                HStack {
                    TextField("Label (e.g. Home)", text: $newLabel)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Address", text: $newAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Button(action: saveAddress) {
                    Label("Save New Address", systemImage: "plus.circle.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(newLabel.isEmpty || newAddress.isEmpty)
            }
            .padding(.horizontal)
        }
        .onAppear(perform: loadAddresses)
    }
    
    // MARK: - Save / Load / Delete Logic
    private func saveAddress() {
        guard !newLabel.isEmpty, !newAddress.isEmpty else { return }
        let new = SavedAddress(label: newLabel, address: newAddress, latitude: 0, longitude: 0)
        savedAddresses.append(new)
        persistAddresses()
        newLabel = ""
        newAddress = ""
    }
    
    private func loadAddresses() {
        if let decoded = try? JSONDecoder().decode([SavedAddress].self, from: savedAddressesData) {
            savedAddresses = decoded
        }
    }
    
    private func persistAddresses() {
        if let encoded = try? JSONEncoder().encode(savedAddresses) {
            savedAddressesData = encoded
        }
    }
    
    private func deleteAddress(at offsets: IndexSet) {
        savedAddresses.remove(atOffsets: offsets)
        persistAddresses()
    }
}

#Preview {
    SavedAddressesView(onSelect: { _ in })
}
