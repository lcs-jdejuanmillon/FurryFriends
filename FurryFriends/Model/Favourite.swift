//
//  Favourite.swift
//  FurryFriends
//
//  Created by Jacobo de Juan Millon on 2022-02-28.
//

import Foundation

struct Favourite: Decodable, Encodable, Hashable {
    let title: String
    let breed: String
    let notes: String
    let image: String
}
