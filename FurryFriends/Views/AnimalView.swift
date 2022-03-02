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
    var url: URL {
        if animal {
            return URL(string: "https://dog.ceo/api/breeds/image/random")!
        }
        return URL(string: "https://aws.random.cat/meow")!
    }
    var body: some View {
        VStack {
            // RemoteImageView(fromURL: currentImage)
            AsyncImage(url: URL(string: currentAnimal.image),
                       content: { downloadedImage in
                downloadedImage
                    .resizable()
                    .scaledToFit()
            },
                       placeholder: {
                ProgressView()
            })
            HStack {
                ZStack {
                    Image(systemName: "heart.circle")
                        .onTapGesture {
                            showFavourites = true
                        }
                        .foregroundColor(.secondary)
                        .opacity(showFavourites || inFavourites ? 0 : 1)
                    Image(systemName: "heart.circle")
                        .onTapGesture {
                            currentAnimal.title = ""
                            currentAnimal.breed = ""
                            currentAnimal.notes = ""
                            showFavourites = false
                        }
                        .foregroundColor(.red)
                        .opacity(showFavourites || inFavourites ? 1 : 0)
                }
                ZStack {
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
                    Button(action: {
                        Task {
                            currentAnimal.image = await newImage(url: url, animal: animal)
                            inFavourites = false
                        }
                    },
                           label: {
                        Text("Another one!")
                    })
                        .buttonStyle(.bordered)
                        .opacity(showFavourites ? 0 : 1)
                }
            }
            VStack {
                TextField("Title", text: $currentAnimal.title)
                TextField("Breed", text: $currentAnimal.breed)
                TextField("Notes", text: $currentAnimal.notes)
            }
            .opacity(showFavourites ? 1 : 0)
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
            currentAnimal.image = await newImage(url: url, animal: animal)
            loadFavourites()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                persistFavourites()
            }
        }
        .navigationTitle(animal ? "Dogs" : "Cats")
        .padding()
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
            AnimalView(animal: true)
        }
    }
}
