//
//  ContentView.swift
//  MyApplication
//
//  Created by Eitan Tuchin on 12/19/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
