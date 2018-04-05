//
//  Collection.swift
//  Musicler
//
//  Created by Andrew Hyatt on 4/4/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Foundation

struct Collection : Codable {
    
    let artistId: Int
    let artistName: String
    let artistViewUrl: URL?
    let artworkUrl100: URL?
    let artworkUrl60: URL?
    let collectionCensoredName: String?
    let collectionExplicitness: String?
    let collectionId: Int
    let collectionName: String
    let collectionType: String
    let collectionViewUrl: String?
    let contentAdvisoryRating: String?
    let copyright: String?
    let country: String?
    let currency: String?
    let longDescription: String?
    let primaryGenreName: String?
    let releaseDate: String?
    let trackCount: Int?
    
}
