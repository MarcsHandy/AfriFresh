import SwiftUI

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @EnvironmentObject var settingsStore: SettingsStore
    @State private var email = ""
    @State private var password = ""
    @State var fullName = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.2), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Spacer()
                    
                    // Logo / Header
                    VStack(spacing: 8) {
                        Image(systemName: "leaf.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(settingsStore.currentTheme.accentColor)
                        
                        Text("AfriFresh")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(settingsStore.currentTheme.textColor)
                        
                        Text("Fresh from farm to table")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 20)
                    
                    // Text Fields
                    VStack(spacing: 16) {
                        TextField("Email", text: $email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            .autocapitalization(.none)
                    }
                    .padding(.horizontal, 30)
                    
                    // Error Message
                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    
                    // Buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            authViewModel.signIn(email: email, password: password)
                        }) {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(settingsStore.currentTheme.accentColor)
                                    .cornerRadius(10)
                            } else {
                                Text("Sign In")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(settingsStore.currentTheme.accentColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        
                        Button(action: {
                            authViewModel.signUp(fullName: fullName, email: email, password: password)
                        }) {
                            Text("Create Account")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .foregroundColor(settingsStore.currentTheme.textColor)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    // Footer
                    Text("By signing in, you agree to AfriFresh’s Terms of Service and Privacy Policy.")
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 10)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    let settings = SettingsStore()
    let authVM = AuthViewModel()
    return LoginView(authViewModel: authVM)
        .environmentObject(settings)
}
