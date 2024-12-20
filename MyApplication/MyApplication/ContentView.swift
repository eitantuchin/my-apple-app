//
//  ContentView.swift
//  MyApplication
//
//  Created by Eitan Tuchin on 12/19/24.
//

import SwiftUI
import SwiftData
import Firebase
import GoogleSignIn


struct ContentView: View {
    @State private var users: [User] = [] // Holds the fetched users
    @State private var isAuthenticated: Bool = false // Tracks authentication state
    
    var body: some View {
        VStack {
            // Show the authenticated view
            List(users) { user in
                VStack(alignment: .leading) {
                    Text(user.username)
                        .font(.headline)
                    Text(user.email)
                        .font(.subheadline)
                    Text(user.id)
                        .font(.subheadline)
                }
            }
            .onAppear {
                fetchUsers() // Fetch users when the view appears
            }
            
        }
    }
    
    // Function to sign in with Google
    /*
     func signInWithGoogle() {
     guard let clientID = FirebaseApp.app()?.options.clientID else { return }
     let config = GIDConfiguration(clientID: clientID)
     
     GIDSignIn.sharedInstance.signIn(with: config, presenting: UIApplication.shared.windows.first!.rootViewController!) { user, error in
     if let error = error {
     print("Google Sign-In error: \(error.localizedDescription)")
     return
     }
     
     guard let user = user,
     let idToken = user.idToken?.tokenString,
     let accessToken = user.accessToken.tokenString else {
     return
     }
     
     let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
     
     // Sign in with Firebase
     Auth.auth().signIn(with: credential) { result, error in
     if let error = error {
     print("Firebase Sign-In error: \(error.localizedDescription)")
     return
     }
     
     // Set authentication state to true
     self.isAuthenticated = true
     }
     }
     }
     */
    
    // Function to fetch users from Firestore
    func fetchUsers() {
        let db = Firestore.firestore()
        
        // Fetch documents from the 'users' collection
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else { return }
            
            // Manually decode each document into a User object
            self.users = snapshot.documents.compactMap { document in
                let data = document.data()
                
                guard let id = document.documentID as String?,
                      let username = data["username"] as? String,
                      let email = data["email"] as? String else {
                    return nil
                }
                
                return User(id: id, username: username, email: email)
            }
        }
    }
}

// Define User model
struct User: Identifiable, Codable {
    var id: String
    var username: String
    var email: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
