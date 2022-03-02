//
//  DogView.swift
//  FurryFriends
//
//  Created by Jacobo de Juan Millon on 2022-02-28.
//

import SwiftUI

struct AnimalView: View {
    // MARK: Stored properties
    @Environment(\.scenePhase) var scenePhase
    let animal: Bool
    @State var favourites: [Favourite] = []
    @State var showFavourites = false
    @State var inFavourites = false
    @State var currentAnimal = Favourite(title: "", breed: "", notes: "", image: "")
    // MARK: Computed properties
    var savedFavouritesLabel: String {
        if animal {
            return "favouriteDogs"
        }
        return "favouriteCats"
    }
    var body: some View {
        VStack {
            // RemoteImageView(fromURL: currentImage
            AsyncImage(url: URL(string: currentAnimal.image),
                       content: { downloadedImage in
                downloadedImage
                    .resizable()
                    .scaledToFit()
            },
                       placeholder: {
                ProgressView()
            })
                .onTapGesture {
                    Task {
                        currentAnimal.image = await newImage(animal: animal)
                        inFavourites = false
                    }
                }
            HeartView(showFavourites: $showFavourites,
                      currentAnimal: $currentAnimal,
                      inFavourites: $inFavourites,
                      favourites: $favourites)
            List(favourites, id: \.self) { currentAnimal in
                VStack {
                    Text(currentAnimal.title)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                    HStack {
                        Text("Breed:")
                        Spacer()
                        Text(currentAnimal.breed)
                            .italic()
                    }
                    Text(currentAnimal.notes)
                    AsyncImage(url: URL(string: currentAnimal.image),
                               content: { downloadedImage in
                        downloadedImage
                            .resizable()
                            .scaledToFit()
                    },
                               placeholder: {
                        ProgressView()
                    })
                    
                }
            }
        }
        .padding()
        .task {
            currentAnimal.image = await newImage(animal: animal)
            favourites = loadFavourites(label: savedFavouritesLabel)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                persistFavourites(label: savedFavouritesLabel,
                                  favourites: favourites)
            }
        }
        .padding()
    }
    // MARK: Functions
}
struct AnimalView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AnimalView(animal: true)
        }
    }
}
