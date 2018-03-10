//
//  Song.swift
//  Musicler
//
//  Created by Andrew Hyatt on 3/8/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Foundation
import SwiftyJSON
import M4ATools

class Song {
    
    enum Explicitness {
        case explicit
        case notExplicit
    }
    
    var trackName: String
    var trackNumber: Int
    var trackCount: Int
    var diskNumber: Int
    var diskCount: Int
    var artistName: String
    var collectionName: String
    var trackExplicit: Explicitness
    var collectionExplicit: Explicitness
    var genreName: String
    var releaseDate: String
    
    var trackID: String
    var collectionID: String
    
    var copyright: String!
    var albumArtist: String!

    required init(trackName: String,
         trackNumber: Int,
         trackCount: Int,
         diskNumber: Int,
         diskCount: Int,
         artistName: String,
         collectionName: String,
         trackExplicit: Explicitness,
         collectionExplicit: Explicitness,
         genreName: String,
         releaseDate: String,
         trackID: String,
         collectionID: String
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
        self.releaseDate = releaseDate
        self.trackID = trackID
        self.collectionID = collectionID
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
            let genreName = json["primaryGenreName"]?.stringValue,
            let releaseDate = json["releaseDate"]?.stringValue,
            let trackID = json["trackId"]?.stringValue,
            let collectionID = json["collectionId"]?.stringValue
        
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
                  genreName: genreName,
                  releaseDate: releaseDate,
                  trackID: trackID,
                  collectionID: collectionID
        )
    }
    
    func fetchAll() {
        guard /*let trackIDURL = URL(string: "https://itunes.apple.com/lookup?id=\(trackID)"),*/
            let collectionIDURL = URL(string: "https://itunes.apple.com/lookup?id=\(collectionID)") else {
            print("\(trackName): Failed to create URL.")
            return
        }
        
        do {
//            let trackIDData = try Data.init(contentsOf: trackIDURL)
//            let trackJSON = try JSON.init(data: trackIDData)
//            let trackResults = trackJSON["results"].arrayValue
//
//            guard trackResults.count == 1 else {
//                print("\(trackName): Failed to fetch copyright.")
//                return
//            }
//            copyright = trackResults[0]["copyright"].stringValue
            
            let collectionIDData = try Data(contentsOf: collectionIDURL)
            let collectionJSON = try JSON(data: collectionIDData)
            let collectionResults = collectionJSON["results"].arrayValue
            
            guard collectionResults.count == 1 else {
                print("\(trackName): Failed to fetch album artist.")
                return
            }
            copyright = collectionResults[0]["copyright"].stringValue
            albumArtist = collectionResults[0]["artistName"].stringValue
        } catch {
            print("\(trackName): Error fetching data!")
        }
    }
    
    func writeMetadata(m4aFile: M4AFile) {
        if copyright == nil {
            print("\(trackName): Doing a network fetch on the mail thread!")
            fetchAll()
        }
        m4aFile.setStringMetadata(.title, value: trackName)
        m4aFile.setStringMetadata(.artist, value: artistName)
        m4aFile.setStringMetadata(.genreCustom, value: genreName)
        m4aFile.setStringMetadata(.album, value: collectionName)
        m4aFile.setTwoIntMetadata(.disc, value: (UInt16(diskNumber), UInt16(diskCount)))
        m4aFile.setTwoIntMetadata(.track, value: (UInt16(trackNumber), UInt16(trackCount)))
        m4aFile.setStringMetadata(.year, value: releaseDate)
        m4aFile.setStringMetadata(.copyright, value: copyright)
        m4aFile.setStringMetadata(.albumArtist, value: albumArtist)
        
        guard let url = m4aFile.url else {
            print("\(trackName): Can't write a file without a URL.")
            return
        }
        do {
            try m4aFile.write(url: url)
        } catch {
            print("\(trackName): Failed to write to file.")
        }
        
    }
    
}
