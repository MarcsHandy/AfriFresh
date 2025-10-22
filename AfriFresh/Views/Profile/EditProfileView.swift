import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var settingsStore: SettingsStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var isSaving: Bool = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // MARK: - Form Fields
                Form {
                    Section(header: Text("Profile Info")) {
                        TextField("Full Name", text: $fullName)
                            .autocapitalization(.words)
                        
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        TextField("Phone Number", text: $phoneNumber)
                            .keyboardType(.phonePad)
                    }
                    
                    // MARK: - Error Message
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                // MARK: - Save Button
                Button(action: saveProfile) {
                    if isSaving {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    } else {
                        Text("Save Changes")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .disabled(isSaving)
                
                Spacer()
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: loadProfile)
        }
    }
    
    // MARK: - Load Current User Data
    private func loadProfile() {
        fullName = authViewModel.user?.fullName ?? ""
        email = authViewModel.user?.email ?? ""
        phoneNumber = authViewModel.user?.phoneNumber ?? ""
    }
    
    // MARK: - Save Profile
    private func saveProfile() {
        guard !fullName.isEmpty, !email.isEmpty else {
            errorMessage = "Name and email cannot be empty."
            return
        }
        
        isSaving = true
        errorMessage = nil
        
        // ✅ Use FirebaseAuth.User here
        let changeRequest = authViewModel.firebaseUser?.createProfileChangeRequest()
        changeRequest?.displayName = fullName
        changeRequest?.commitChanges { error in
            DispatchQueue.main.async {
                isSaving = false
                if let error = error {
                    errorMessage = error.localizedDescription
                    return
                }
                
                authViewModel.firebaseUser?.updateEmail(to: email) { emailError in
                    if let emailError = emailError {
                        errorMessage = emailError.localizedDescription
                        return
                    }
                    
                    // Optionally update local app user
                    authViewModel.user?.fullName = fullName
                    authViewModel.user?.email = email
                    authViewModel.user?.phoneNumber = phoneNumber
                    
                    dismiss()
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    let authVM = AuthViewModel()
    let settingsStore = SettingsStore()
    
    EditProfileView()
        .environmentObject(authVM)
        .environmentObject(settingsStore)
}

