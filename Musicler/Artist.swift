//
//  Artist.swift
//  Musicler
//
//  Created by Andrew Hyatt on 4/4/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Foundation

struct Artist : Codable {
    
    let artistId: String
    let artistLinkUrl: URL?
    let artistName: String
    let artistType: String
    let primaryGenreId: Int?
    let primaryGenreName: String?
    
}
