//
//  Track.swift
//  Musicler
//
//  Created by Andrew Hyatt on 4/4/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Foundation

struct Track : Codable {
    
    let artistName: String
    let artworkUrl100: URL?
    let artworkUrl30: URL?
    let artworkUrl60: URL?
    let artistId: Int?
    let collectionArtistId: Int?
    let collectionArtistViewUrl: URL?
    let collectionCensoredName: String?
    let collectionExplicitness: String?
    let collectionId: Int?
    let collectionName: String?
    let collectionViewUrl: URL?
    let contentAdvisoryRating: String?
    let country: String?
    let currency: String?
    let discCount: Int?
    let discNumber: Int?
    let hasITunesExtras: Bool?
    let kind: String?
    let shortDescription: String?
    let longDescription: String?
    let previewUrl: URL?
    let primaryGenreName: String?
    let releaseDate: String?
    let trackCensoredName: String?
    let trackCount: Int?
    let trackExplicitness: String?
    let trackId: Int?
    let trackName: String?
    let trackNumber: Int?
    let trackTimeMillis: Double?
    let trackViewUrl: URL?
    let wrapperType: String
    
}
