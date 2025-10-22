import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user: User?              // Your app's User model
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var showOnboarding: Bool = true
    @Published var firebaseUser: FirebaseAuth.User?

    private var handle: AuthStateDidChangeListenerHandle?
    private let db = Firestore.firestore()

    init() {
        listenToAuthChanges()
    }

    private func listenToAuthChanges() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] (_, firebaseUser) in
            guard let self = self else { return }
            Task {
                if let firebaseUser = firebaseUser {
                    self.firebaseUser = firebaseUser
                    await self.fetchOrCreateUser(firebaseUser: firebaseUser)
                } else {
                    await MainActor.run {
                        self.user = nil
                        self.firebaseUser = nil
                        self.isAuthenticated = false
                    }
                }
            }
        }
    }

    func signIn(email: String, password: String) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let result = try await Auth.auth().signIn(withEmail: email, password: password)
                await fetchOrCreateUser(firebaseUser: result.user)
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    func signUp(fullName: String, email: String, password: String) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let result = try await Auth.auth().createUser(withEmail: email, password: password)

                let newUser = User(
                    id: result.user.uid,
                    fullName: fullName,
                    email: email,
                    phoneNumber: nil,
                    address: nil,
                    createdAt: Date(),
                    orderIDs: []
                )

                try db.collection("users").document(result.user.uid).setData(from: newUser)

                await MainActor.run {
                    self.user = newUser
                    self.isAuthenticated = true
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    private func fetchOrCreateUser(firebaseUser: FirebaseAuth.User) async {
        do {
            let docRef = db.collection("users").document(firebaseUser.uid)
            let snapshot = try await docRef.getDocument()
            
            // Decode directly
            let fetchedUser = try snapshot.data(as: User.self)  // This is NOT optional anymore
            
            await MainActor.run {
                self.user = fetchedUser
                self.isAuthenticated = true
                self.isLoading = false
            }
        } catch {
            // If decoding fails, create a new user
            do {
                let newUser = User(
                    id: firebaseUser.uid,
                    fullName: firebaseUser.displayName ?? "Unknown",
                    email: firebaseUser.email ?? "",
                    phoneNumber: nil,
                    address: nil,
                    createdAt: Date(),
                    orderIDs: []
                )
                try db.collection("users").document(firebaseUser.uid).setData(from: newUser)
                
                await MainActor.run {
                    self.user = newUser
                    self.isAuthenticated = true
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
            isAuthenticated = false
            print("🚪 Signed out successfully")
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
