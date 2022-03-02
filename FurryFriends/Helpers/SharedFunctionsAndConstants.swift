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

struct dogJSON: Decodable {
    var message: String
    var status: String
}

struct catJSON: Decodable {
    var file: String
}

struct Favourite: Decodable, Encodable, Hashable {
    var title: String
    var breed: String
    var notes: String
    var image: String
}

func newImage (animal: Bool) async -> String  {
    let url = animal ? URL(string: "https://dog.ceo/api/breeds/image/random")! : URL(string: "https://aws.random.cat/meow")!
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

func persistFavourites(label: String, favourites: [Favourite]) {
    let filename = getDocumentsDirectory().appendingPathComponent(label)
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

func loadFavourites(label: String) -> [Favourite] {
    let filename = getDocumentsDirectory().appendingPathComponent(label)
    print(filename)
    do {
        let data = try Data(contentsOf: filename)
        print("Saved data to the Documents directory successfully.")
        print("==========")
        print(String(data: data, encoding: .utf8)!)
        return try JSONDecoder().decode([Favourite].self, from: data)
    } catch {
        print("Could not load the data from the stored JSON file")
        print("========")
        print(error.localizedDescription)
        return []
    }
}
