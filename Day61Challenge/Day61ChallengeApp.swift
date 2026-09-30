//
//  Day61ChallengeApp.swift
//  Day61Challenge
//
//  Created by Myron Snelson on 9/26/26.
//

import SwiftUI
import SwiftData

@main
struct Day61ChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Added the SwiftData model container to the app.
        .modelContainer(for: User.self)
    }
}
