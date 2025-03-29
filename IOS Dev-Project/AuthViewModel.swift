import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false

    init() {
        checkAuthState()
    }

    func checkAuthState() {
        if Auth.auth().currentUser != nil {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }

    func signIn(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(error.localizedDescription)
                } else {
                    self.isAuthenticated = true
                    completion(nil)
                }
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch {
            print("Sign out error: \(error.localizedDescription)")
        }
    }
}

