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

struct StartScreen: View {
    @State private var isAuthenticated: Bool = false // Tracks authentication
    @State private var isLoading: Bool = true // Tracks whether to show the loading screen

    var body: some View {
            Group {
                if isLoading {
                    LoadingScreen()
                        .onAppear {
                            // Simulate loading or perform startup tasks
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5 ) {
                                isLoading = false
                            }
                        }
                } else {
                    VStack {
                        if isAuthenticated {
                            // Authenticated content
                            EventsScreen()
                        } else {
                            // Sign-in button
                            Button(action: signInWithGoogle) {
                                Text("Sign in with Google")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            Button(action: signInWithApple) {
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
            }
        }
    
    func signInWithApple() {
        
    }

    func signInWithGoogle() {
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

#Preview {
    StartScreen()
}
