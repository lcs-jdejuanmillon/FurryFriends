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
    // Address for main image
    // Starts as a transparent pixel – until an address for an animal's image is set
    @State var currentImage = URL(string: "https://www.russellgordon.ca/lcs/miscellaneous/transparent-pixel.png")!
    
    // MARK: Computed properties
    var savedFavouritesLabel: String {
        if animal {
            return "favouriteDogs"
        }
        return "favouriteCats"
    }
    var url: URL {
        if animal {
            return URL(string: "https://images.dog.ceo/breeds/labrador/lab_young.JPG")!
        }
        return URL(string: "https://images.dog.ceo/breeds/labrador/lab_young.JPG")!
    }
    var body: some View {
        ScrollView {
            VStack {
                RemoteImageView(fromURL: currentImage)
                HStack {
                    Button(action: {
                        print("Hola")
                    },
                           label: {
                        Text("Add to Favourite")
                    })
                        .buttonStyle(.bordered)
                    Button(action: {
                        print("Hola")
                    },
                           label: {
                        Text("Another one!")
                    })
                        .buttonStyle(.bordered)
                }
                Spacer()
                
            }
            // Runs once when the app is opened
            .task {
                let remoteDogImage = "https://images.dog.ceo/breeds/labrador/lab_young.JPG"
                
                // Replaces the transparent pixel image with an actual image of an animal
                // Adjust according to your preference ☺️
                currentImage = URL(string: remoteDogImage)!
            }
        }
        .navigationTitle("Dogs")
    }
    
    // MARK: Functions
    func persistFavourites() {
        let filename = getDocumentsDirectory().appendingPathComponent(savedFavouritesLabel)
        print(filename)
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(favourites)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            print("Saved data to the Documents directory successfully.")
            print("==========")
            print(String(data: data, encoding: .utf8)!)
        } catch {
            print("Unable to write list of favourites to the Documents directory")
            print("===========")
            print(error.localizedDescription)
        }
    }
    func loadFavourites() {
        let filename = getDocumentsDirectory().appendingPathComponent(savedFavouritesLabel)
        print(filename)
        do {
            let data = try Data(contentsOf: filename)
            print("Saved data to the Documents directory successfully.")
            print("==========")
            print(String(data: data, encoding: .utf8)!)
            favourites = try JSONDecoder().decode([Favourite].self, from: data)
        } catch {
            print("Could not load the data from the stored JSON file")
            print("========")
            print(error.localizedDescription)
        }
    }
}

struct AnimalView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AnimalView(animal: false)
        }
    }
}
