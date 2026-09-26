//
//  DetailView.swift
//  Day61Challenge
//
//  Created by Myron Snelson on 9/26/26.
//

import SwiftUI

struct DetailView: View {
    let user: User

  //  For use with the user.tags array
  //  Swift infers its type as [GridItem]—an array of grid-column descriptions.
  //  GridItem(...) describes one kind of column for a LazyVGrid.
  //  .adaptive(minimum: 80) tells SwiftUI to create as many columns as will fit, with each column being at least 80 points wide.
   // alignment: .leading places each tag at the leading edge of its grid cell—usually the left edge in left-to-right languages.

   // The array contains only one GridItem, but because that item is adaptive, it can produce multiple columns automatically.
    private let tagColumns = [
        GridItem(.adaptive(minimum: 80), alignment: .leading)
    ]

    private var emailURL: URL? {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = user.email
        return components.url
    }

    var body: some View {
        List {
            Section("Profile") {
                // LabeledContent is a SwiftUI container that
                // presents a descriptive label alongside a
                // corresponding value or view.
                // It’s particularly useful inside a Form, where
                // SwiftUI automatically aligns labels and values
                // consistently.
                LabeledContent("Name", value: user.name)

                LabeledContent("Status") {
                    HStack(spacing: 6) {
                        Image(
                            systemName: user.isActive
                                ? "checkmark.circle.fill"
                                : "xmark.circle.fill"
                        )
                        Text(user.isActive ? "Active" : "Inactive")
                    }
                    .fixedSize()
                    .foregroundStyle(user.isActive ? .green : .red)
                }
                
                // format: .number tells SwiftUI to convert the numeric user.age value into localized text for display.
                LabeledContent("Age", value: user.age, format: .number)
                
                LabeledContent("Company", value: user.company)

                LabeledContent("Email") {
                    if let emailURL {
                        Link(user.email, destination: emailURL)
                    } else {
                        Text(user.email)
                    }
                }

                LabeledContent("Registered") {
                    Text(user.registered, format: .dateTime.month(.wide).day().year())
                }
            }

            Section("About") {
                Text(user.about)
            }

            Section("Tags") {
                if user.tags.isEmpty {
                    Text("No tags")
                        .foregroundStyle(.secondary)
                } else {
                    LazyVGrid(columns: tagColumns, alignment: .leading, spacing: 8) {
                        ForEach(user.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.subheadline)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(.tint.opacity(0.12), in: Capsule())
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            Section("Friends") {
                if user.friends.isEmpty {
                    Text("No friends")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(user.friends, id: \.id) { friend in
                        // Label is a SwiftUI view designed to
                        // combine an icon with text
                        // Although the title appears first in the
                        // initializer, SwiftUI’s standard Label
                        // style lays it out as: person image,
                        // friend name
                        Label(friend.name, systemImage: "person")
                    }
                }
            }
        }
        .navigationTitle(user.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let example = User(id: UUID(), isActive: true, name: "Joe", age: 31, company: "Beluga", email: "whale@beluga.com", about: "Fred", registered: .now, tags: [], friends: [])
    DetailView(user: example)
}
