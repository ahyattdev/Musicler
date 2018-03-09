//
//  Song.swift
//  Musicler
//
//  Created by Andrew Hyatt on 3/8/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Foundation
import SwiftyJSON

class Song {
    
    enum Explicitness {
        case explicit
        case notExplicit
    }
    
    let trackName: String
    let trackNumber: Int
    let trackCount: Int
    let diskNumber: Int
    let diskCount: Int
    let artistName: String
    let collectionName: String
    let trackExplicit: Explicitness
    let collectionExplicit: Explicitness
    let genreName: String
    

    required init(trackName: String,
         trackNumber: Int,
         trackCount: Int,
         diskNumber: Int,
         diskCount: Int,
         artistName: String,
         collectionName: String,
         trackExplicit: Explicitness,
         collectionExplicit: Explicitness,
         genreName: String
         ) {
        self.trackName = trackName
        self.trackNumber = trackNumber
        self.trackCount = trackCount
        self.diskNumber = diskNumber
        self.diskCount = diskCount
        self.artistName = artistName
        self.collectionName = collectionName
        self.trackExplicit = trackExplicit
        self.collectionExplicit = collectionExplicit
        self.genreName = genreName
    }
    
    convenience init?(json: [String: JSON]){
        guard let trackName = json["trackName"]?.stringValue,
            let trackNumber = json["trackNumber"]?.intValue,
            let trackCount = json["trackCount"]?.intValue,
            let diskNumber = json["discNumber"]?.int,
            let diskCount = json["discCount"]?.int,
            let artistName = json["artistName"]?.stringValue,
            let collectionName = json["collectionName"]?.stringValue,
            let trackExplicitString = json["trackExplicitness"]?.stringValue,
            let collectionExplicitString = json["collectionExplicitness"]?.stringValue,
            let genreName = json["primaryGenreName"]?.stringValue
        
        
        else {
            return nil
        }
        
        let trackExplicit: Explicitness = trackExplicitString == "explicit"
            ? .explicit : .notExplicit
        let collectionExplicit: Explicitness = collectionExplicitString == "explicit"
            ? .explicit : .notExplicit
        
        self.init(trackName: trackName,
                  trackNumber: trackNumber,
                  trackCount: trackCount,
                  diskNumber: diskNumber,
                  diskCount: diskCount,
                  artistName: artistName,
                  collectionName: collectionName,
                  trackExplicit: trackExplicit,
                  collectionExplicit: collectionExplicit,
                  genreName: genreName)
    }
}
