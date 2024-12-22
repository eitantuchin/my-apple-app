//
//  ContentView.swift
//  MyApplication
//
//  Created by Eitan Tuchin on 12/19/24.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseAuth

struct ContentView: View {
    @State private var users: [User] = [] // Holds the fetched users
    @State private var isAuthenticated: Bool = false // Tracks authentication

    var body: some View {
        VStack {
            if isAuthenticated {
                // Show authenticated content
                List(users) { user in
                    VStack(alignment: .leading) {
                        Text(user.username)
                            .font(.headline)
                        Text(user.email)
                            .font(.subheadline)
                    }
                }
                .onAppear {
                    fetchUsers() // Fetch users when the view appears
                }
            } else {
                // Show sign-in button for unauthenticated users
                Button(action: signIn) {
                    Text("Sign in with Google")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }

    // Function to fetch users from Firestore
    func fetchUsers() {
        let db = Firestore.firestore()

        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                return
            }

            guard let snapshot = snapshot else { return }

            self.users = snapshot.documents.compactMap { document in
                let data = document.data()
                guard let username = data["username"] as? String,
                      let email = data["email"] as? String else {
                    return nil
                }
                return User(id: document.documentID, username: username, email: email)
            }
        }
    }

    func signIn() {
        // Get the presenting view controller
        guard let presentingViewController = getRootViewController() else {
            print("Unable to get the root view controller")
            return
        }

        // Perform Google Sign-In
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
            if let error = error {
                print("Error during Google Sign-In:\(error.localizedDescription)")
                return
            }

            // Get the ID token and access token from the result
            guard let result = result,
                  let idToken = result.user.idToken?.tokenString else {
                print("Unable to retrieve ID token")
                return
            }

            // AccessToken is non-optional, no need for conditional binding
            let accessToken = result.user.accessToken.tokenString

            // Use tokens to authenticate with Firebase
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error during Firebase Sign-In: \(error.localizedDescription)")
                    return
                }

                // Successfully signed in
                isAuthenticated = true
                print("User is authenticated with Firebase")
            }
        }
    }

    private func getRootViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        return windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Define User model
struct User: Identifiable, Codable {
    var id: String
    var username: String
    var email: String
}

