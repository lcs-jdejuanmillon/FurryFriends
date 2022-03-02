//
//  HeartView.swift
//  FurryFriends
//
//  Created by Jacobo de Juan Millon on 2022-03-02.
//

import SwiftUI

struct HeartView: View {
    @Binding var showFavourites: Bool
    @Binding var currentAnimal: Favourite
    @Binding var inFavourites: Bool
    @Binding var favourites: [Favourite]
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Image(systemName: "heart.circle")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.secondary)
                        .opacity(showFavourites || inFavourites ? 0 : 1)
                        .onTapGesture {
                            showFavourites = true
                        }
                    Image(systemName: "heart.circle")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.red)
                        .opacity(showFavourites || inFavourites ? 1 : 0)
                        .onTapGesture {
                            currentAnimal.title = ""
                            currentAnimal.breed = ""
                            currentAnimal.notes = ""
                            showFavourites = false
                        }
                }
                Button(action: {
                    favourites.append(currentAnimal)
                    currentAnimal.title = ""
                    currentAnimal.breed = ""
                    currentAnimal.notes = ""
                    showFavourites = false
                    inFavourites = true
                },
                       label: {
                    Text("Save")
                })
                    .buttonStyle(.bordered)
                    .opacity(showFavourites ? 1 : 0)
            }
            VStack {
                TextField("Title", text: $currentAnimal.title)
                TextField("Breed", text: $currentAnimal.breed)
                TextField("Notes", text: $currentAnimal.notes)
            }
        }
    }
}
