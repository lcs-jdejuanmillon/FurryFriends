//
//  VersusView.swift
//  FurryFriends
//
//  Created by Jacobo de Juan Millon on 2022-02-28.
//

import SwiftUI

struct VersusView: View {
    
    // MARK: Stored properties
    // Address for main image
    // Starts as a transparent pixel – until an address for an animal's image is set
    @State var currentCat = Favourite(title: "", breed: "", notes: "", image: "")
    @State var currentDog = Favourite(title: "", breed: "", notes: "", image: "")
    @State var numbers = [0.0, 0.0]
    @State var showDog = false
    @State var showCat = false
    @State var inDog = false
    @State var inCat = false
    // MARK: Computed properties
    var sum: Double {
        return max(1, numbers[0] + numbers[1])
    }
    var body: some View {
        VStack {
            Text("Dogs Vs Cats")
            Text("Tap on the animal you like the most")
            HStack {
                Spacer()
                Text("\(String(format: "%.0f", numbers[0] / sum * 100))%")
                Spacer()
                Text("VS")
                Spacer()
                Text("\(String(format: "%.0f", numbers[1] / sum * 100))%")
                Spacer()
            }
            .opacity(numbers[0] + numbers[1] == 0 ? 0 : 1)
            HStack {
                AsyncImage(url: URL(string: currentDog.image),
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
                            numbers[0] += 1
                            currentDog.image = await newImage(animal: true)
                            currentCat.image = await newImage(animal: false)
                        }
                    }
                AsyncImage(url: URL(string: currentCat.image),
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
                            numbers[1] += 1
                            currentDog.image = await newImage(animal: true)
                            currentCat.image = await newImage(animal: false)
                        }
                    }
                
            }
            HStack {
                Spacer()
                HeartView(showFavourites: $showDog,
                          currentAnimal: $currentDog,
                          inFavourites: $inDog,
                          favourites: $favouritesDog)
                Spacer()
                Spacer()
                Image(systemName: "heart.circle")
                    .resizable()
                    .frame(width: 35, height: 35)
                Spacer()
            }

            Spacer()
            
        }
        // Runs once when the app is opened
        .task {
            currentDog.image = await newImage(animal: true)
            currentCat.image = await newImage(animal: false)
        }
    }
    
    // MARK: Functions
    func loadFavourites() {
        let filename = getDocumentsDirectory().appendingPathComponent("numbers")
        print(filename)
        do {
            let data = try Data(contentsOf: filename)
            print("Saved data to the Documents directory successfully.")
            print("==========")
            print(String(data: data, encoding: .utf8)!)
            numbers = try JSONDecoder().decode([Double].self, from: data)
        } catch {
            print("Could not load the data from the stored JSON file")
            print("========")
            print(error.localizedDescription)
        }
    }
    
}

struct VersusView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VersusView()
        }
    }
}

// Add extra to the JSON file or create an auxialiary second file

