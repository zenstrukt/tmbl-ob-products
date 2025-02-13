//
//  testApp.swift
//  test
//
//  Created by Jake Tachdjian on 13/2/2025.
//

import SwiftUI

@main
struct testApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false  // Store user preference

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)  // 🔥 Ensure global dark mode
        }
    }
}
