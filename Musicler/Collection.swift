//
//  Collection.swift
//  Musicler
//
//  Created by Andrew Hyatt on 4/4/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Foundation

struct Collection : Codable {
    
    let wrapperType: String
    let collectionType: String
    let artistId: String
    let collectionId: Int
    let amgArtistId: Int?
    let artistName: String
    let collectionName: String
    let collectionCensoredName: String
    let artistViewUrl: URL?
    let collectionViewUrl: URL
    let artworkUrl60: URL
    let artworkUrl100: URL
    let collectionPrice: Double?
    let collectionExplicitness: String
    let contentAdvisoryRating: String?
    let trackCount: Int
    let copyright: String
    let country: String
    let currency: String
    let releaseDate: String
    let primaryGenreName: String?
    
}
