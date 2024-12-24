//
//  LoadingScreen.swift
//  MyApplication
//
//  Created by Eitan Tuchin on 12/23/24.
//

import SwiftUI

struct LoadingScreen: View {
    var body: some View {
        ZStack {
            // Background color
            Color("cardinal")
                .ignoresSafeArea()

            // App logo in the middle
            Image("app_logo") // Replace with your app logo asset
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150) // Adjust the size as needed
                .cornerRadius(20)
        }
    }
}

#Preview {
    LoadingScreen()
}
