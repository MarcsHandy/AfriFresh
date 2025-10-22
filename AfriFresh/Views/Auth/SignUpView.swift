import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @ObservedObject var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var fullName = ""
    
    @State private var isLoading = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            
            // MARK: - Header
            VStack(spacing: 8) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(settingsStore.currentTheme.textColor)
                
                Text("Sign up to start ordering fresh produce")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            
            // MARK: - Form
            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
            }
            .padding(.horizontal)
            
            // MARK: - Error Message
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // MARK: - Sign Up Button
            Button(action: {
                signUp()
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(settingsStore.currentTheme.accentColor)
                        .cornerRadius(10)
                } else {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(settingsStore.currentTheme.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            .disabled(isLoading)
            
            // MARK: - Already have an account
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.secondary)
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Login")
                        .foregroundColor(settingsStore.currentTheme.accentColor)
                        .fontWeight(.semibold)
                }
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .background(settingsStore.currentTheme.backgroundColor)
        .navigationBarHidden(true)
    }
    
    // MARK: - Sign Up Logic
    private func signUp() {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            authViewModel.errorMessage = "Please fill all fields"
            return
        }
        
        guard password == confirmPassword else {
            authViewModel.errorMessage = "Passwords do not match"
            return
        }
        
        isLoading = true
        authViewModel.signUp(fullName: fullName, email: email, password: password)
        
        // Listen for completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            if authViewModel.isAuthenticated {
                authViewModel.errorMessage = nil
            }
        }
    }
}

// MARK: - Preview

#Preview {
    let settingsStore = SettingsStore()
    let authViewModel = AuthViewModel()
    
    NavigationView {
        SignUpView(authViewModel: authViewModel)
            .environmentObject(settingsStore)
    }
}

