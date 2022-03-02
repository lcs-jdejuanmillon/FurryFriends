//
//  SharedFunctionsAndConstants.swift
//  FurryFriends
//
//  Created by Jacobo de Juan Millon on 2022-02-28.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

struct dogJSON: Decodable, Encodable, Hashable {
    var message: String
    var status: String
}

struct catJSON: Decodable, Encodable, Hashable {
    var file: String
}

struct Favourite: Decodable, Encodable, Hashable {
    var title: String
    var breed: String
    var notes: String
    var image: String
}

func newImage (url: URL, animal: Bool) async -> String  {
    var request = URLRequest(url: url)
    // Ask for JSON data
    request.setValue("application/json",
                     forHTTPHeaderField: "Accept")
    
    let urlSession = URLSession.shared
    do {
        
        // Get the raw data from the endpoint
        let (data, _) = try await urlSession.data(for: request)
        
        // Attempt to decode the raw data into a Swift structure
        //                                 DATA TYPE TO DECODE TO
        //                                         |
        //                                         V
        if animal {
            return try JSONDecoder().decode(dogJSON.self, from: data).message
        }
        return try JSONDecoder().decode(catJSON.self, from: data).file
    } catch {
        print("Could not retrieve or decode the JSON from endpoint.")
        // Print the contents of the "error" constant that the do-catch block
        // populates
        print(error)
        return "Something went wrong, hopefully it does not crash"
    }
}
