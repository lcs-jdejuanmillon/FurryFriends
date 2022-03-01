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
    let message: String
    let status: String
}

struct catJSON: Decodable, Encodable, Hashable {
    let file: String
}

struct Favourite: Decodable, Encodable, Hashable {
    let title: String
    let breed: String
    let notes: String
    let image: String
}
