//
//  DogImageView.swift
//  FurryFriends
//
//  Created by Russell Gordon on 2022-02-26.
//

import SwiftUI

struct DogImageView: View {
    
    // MARK: Stored properties
    let url = URL(string: "https://dog.ceo/api/breeds/image/random")!
    @State var dog: dogJSON = dogJSON(message: "https://images.dog.ceo/breeds/bulldog-english/mami.jpg",
                                      status: "")
    // MARK: Computed properties
    var body: some View {
        AsyncImage(url: URL(string: dog.message)!,
                   content: { downloadedImage in
            downloadedImage
                .resizable()
                .scaledToFit()
        },
                   placeholder: {
            ProgressView()
        })
            .task {
                await newImage()
            }
    }
    func newImage () async {
        // Define the type of data we want from the endpoint
        // Configure the request to the web site
        var request = URLRequest(url: url)
        // Ask for JSON data
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        
        // Start a session to interact (talk with) the endpoint
        let urlSession = URLSession.shared
        
        // Try to fetch a new joke
        // It might not work, so we use a do-catch block
        do {
            
            // Get the raw data from the endpoint
            let (data, _) = try await urlSession.data(for: request)
            
            // Attempt to decode the raw data into a Swift structure
            // Takes what is in "data" and tries to put it into "currentQuote"
            //                                 DATA TYPE TO DECODE TO
            //                                         |
            //                                         V
            dog = try JSONDecoder().decode(dogJSON.self, from: data)
            print("Run")
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            // Print the contents of the "error" constant that the do-catch block
            // populates
            print(error)
        }
    }
}
struct DogImageView_Previews: PreviewProvider {
    static var previews: some View {
        DogImageView()
    }
}
