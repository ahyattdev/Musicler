//
//  iTunesResult.swift
//  Musicler
//
//  Created by Andrew Hyatt on 4/4/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Foundation
import M4ATools

struct iTunesResult {
    
    var track: Track
    var artist: Artist?
    var collection: Collection?
    
    init(track: Track) {
        self.track = track
    }
    
    class MetadataEntry : NSObject {
        
        let title: String
        let value: String
        
        init(title: String, value: String) {
            self.title = title
            self.value = value
        }
        
    }
    
    func writeMetadata(m4aFile: M4AFile) {
        guard /*let artist = artist,*/ let collection = collection else {
            print("\(track.trackName): Didn't fetch the rest of the metadata!")
            return
        }
        
        m4aFile.setStringMetadata(.title, value: track.trackName)
        m4aFile.setStringMetadata(.artist, value: track.artistName)
        m4aFile.setStringMetadata(.genreCustom, value: track.primaryGenreName)
        m4aFile.setStringMetadata(.album, value: track.collectionName)
        m4aFile.setTwoIntMetadata(.disc, value: (UInt16(track.discNumber), UInt16(track.discCount)))
        m4aFile.setTwoIntMetadata(.track, value: (UInt16(track.trackNumber), UInt16(track.trackCount)))
        m4aFile.setStringMetadata(.year, value: track.releaseDate)
        m4aFile.setStringMetadata(.copyright, value: collection.copyright)
        m4aFile.setStringMetadata(.albumArtist, value: collection.artistName)
        
        // Set sorting for album, artist, and name
        m4aFile.setStringMetadata(.sortingAlbum, value: track.collectionName)
        m4aFile.setStringMetadata(.sortingArtist, value: track.artistName)
        m4aFile.setStringMetadata(.sortingTitle, value: track.trackName)
        if track.trackExplicitness == "explicit" {
            m4aFile.setUInt8Metadata(.rating, value: 0b00000001)
        }
        guard let url = m4aFile.url else {
            print("\(track.trackName): Can't write a file without a URL.")
            return
        }
        do {
            try m4aFile.write(url: url)
        } catch {
            print("\(track.trackName): Failed to write to file.")
        }

    }
    
    func getDisplayData() -> [MetadataEntry] {
        var metadata = [MetadataEntry]()
        
        metadata.append(MetadataEntry(title: "Name", value: track.trackName))
        metadata.append(MetadataEntry(title: "Artist", value: track.artistName))
        if let collection = collection {
            metadata.append(MetadataEntry(title: "Album Artist", value: collection.artistName))
        }
        metadata.append(MetadataEntry(title: "Album", value: track.artistName))
        metadata.append(MetadataEntry(title: "Genre", value: track.primaryGenreName))
        metadata.append(MetadataEntry(title: "Release Date", value: track.releaseDate))
        metadata.append(MetadataEntry(title: "Track Number", value: "\(track.trackNumber) of \(track.trackCount)"))
        metadata.append(MetadataEntry(title: "Disc Number", value: "\(track.discNumber) of \(track.discCount)"))
        if let collection = collection {
            metadata.append(MetadataEntry(title: "Copyright", value: collection.copyright))
        }
        
        return metadata
    }
    

}
