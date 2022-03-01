//
//  FurryFriendsApp.swift
//  FurryFriends
//
//  Created by Russell Gordon on 2022-02-26.
//

import SwiftUI

@main
struct FurryFriendsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                TabView {
                    AnimalView(animal: true)
                        .tabItem {
                            Image("DOG")
                            Text("Dogs")
                        }
                    AnimalView(animal: false)
                        .tabItem {
                            Image("CAT")
                            Text("Cats")
                        }
                }
            }
        }
    }
}
