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
    @State var currentImage = URL(string: "https://www.russellgordon.ca/lcs/miscellaneous/transparent-pixel.png")!
    let remoteDogImage = "https://images.dog.ceo/breeds/labrador/lab_young.JPG"
    let remoteCatImage = "https://purr.objects-us-east-1.dream.io/i/JJiYI.jpg"
    // MARK: Computed properties
    var body: some View {
        ScrollView {
            VStack {
                Text("Dogs Vs Cats")
                HStack {
                    RemoteImageView(fromURL: URL(string: remoteDogImage)!)
                    RemoteImageView(fromURL: URL(string: remoteCatImage)!)
                }
                HStack {
                    Spacer()
                    Image(systemName: "heart.circle")
                        .resizable()
                        .frame(width: 35, height: 35)
                    Spacer()
                    Button(action: {
                        print("Hola")
                    },
                           label: {
                        Text("New")
                    })
                        .buttonStyle(.bordered)
                    Spacer()
                    Image(systemName: "heart.circle")
                        .resizable()
                        .frame(width: 35, height: 35)
                    Spacer()
                }
                Text("Tap on the animal you like the most")
                HStack {
                    Spacer()
                    Text("80%")
                    Spacer()
                    Text("VS")
                    Spacer()
                    Text("20%")
                    Spacer()
                }
                Spacer()
                
            }
            // Runs once when the app is opened
            .task {
                
                
                // Replaces the transparent pixel image with an actual image of an animal
                // Adjust according to your preference ☺️
                currentImage = URL(string: remoteDogImage)!
            }
        }
    }
    
    // MARK: Functions
    
}

struct VersusView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VersusView()
        }
    }
}
