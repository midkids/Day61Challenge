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
        .modelContainer(for: User.self)
    }
}
