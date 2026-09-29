//
//  ContentView.swift
//  Day61Challenge
//
//  Created by Myron Snelson on 9/26/26.
//

import SwiftUI
import SwiftData

// Here we will be sending and receiving data
// from the Internet
// Combined with Codable support, we will
// 2) receive JSON and convert that into
//    to Swift objects
// 3) when our request completes, we can
//    immediately assign that data to
//    properties in our SwiftUI views
//    causing them to update the user
//    inteface immediately

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \User.name) private var users: [User]

    var body: some View {
        NavigationStack {
            List(users) { user in
                NavigationLink(value: user) {
                    HStack {
                        Text(user.name)
                            .font(.headline)
                        Text(user.isActive ? "Active" : "Inactive")
                    }
                }
            }
            .navigationTitle("Users")
            .navigationDestination(for: User.self) {
                user in DetailView(user: user)
            }
            // The task modifier works with asynchronous
            // functions
            // await tells SwiftUI a sleep MIGHT happen here
            .task {
                await loadDataIfNeeded()
            }
        }
    }
    
    // Networking can be slow compared to local
    // functions - Async tells Swift to
    // leave this this code working away in the
    // background while the main app carries on
    // working
    
    // Use of the keyword async tells Swift
    // this function might want to go to sleep
    // so the app can carry on while waiting
    // for some other work to complete
    // In this case, this means going to sleep
    // while our networking code happens
    // so that our app does not freeze up
    
    // The three steps we want to complete:
    // 1. Create the URL from which we want to
    //    retrieve data
    // 2. We want to fetch the data from that
    //    URL using Swift
    // 3. Decode that result into an array of User values
    func loadDataIfNeeded() async {
        do {
            let userCount = try modelContext.fetchCount(FetchDescriptor<User>())
            guard userCount == 0 else { return }
        } catch {
            print("Unable to check for saved users: \(error)")
            return
        }

        // Get some JSON data Paul created
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }
        
        do  {
            // The return value is a tuple
            // and this tuple will contain
            // the data we want and also metadata
            // We don't want that metadata
            // This statement says: place the returned
            // actual data in the variable data
            // and the underscore says to discard
            // the metadata
            // IMPORTANT: must use "try await"
            //  in that order
            // try: there might be errors here
            // await: there might be sleeping here
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            
            // The date each user registered has a very
            // specific format: 2015-11-10T01:47:18-00:00
            // This is known as ISO-8601, and is so common that
            // there’s a built-in dateDecodingStrategy called
            // .iso8601 that decodes it automatically
            decoder.dateDecodingStrategy = .iso8601
            let downloadedUsers = try decoder.decode([User].self, from: data)

            for user in downloadedUsers {
                modelContext.insert(user)
            }

            try modelContext.save()
        } catch {
            // If our data retrieval above fails for any
            // reason, we simply print an error message
            // and do nothing more
            print("Invalid data: \(error)")
        }
    
    }
}

#Preview {
    ContentView()
        .modelContainer(for: User.self, inMemory: true)
}
