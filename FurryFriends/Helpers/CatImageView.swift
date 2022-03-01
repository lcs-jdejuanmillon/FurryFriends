//
//  CatImageView.swift
//  FurryFriends
//
//  Created by Russell Gordon on 2022-02-26.
//

import SwiftUI

struct CatImageView: View {
    
    // MARK: Stored properties
    let url = URL(string: "https://aws.random.cat/meow")!
    @State var cat: catJSON = catJSON(file: "https://images.dog.ceo/breeds/bulldog-english/mami.jpg")
    // MARK: Computed properties
    var body: some View {
        AsyncImage(url: URL(string: cat.file)!,
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
            cat = try JSONDecoder().decode(catJSON.self, from: data)
            print("Run")
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            // Print the contents of the "error" constant that the do-catch block
            // populates
            print(error)
        }
    }
}
struct RemoteImageView_Previews: PreviewProvider {
    static var previews: some View {
        CatImageView()
    }
}
