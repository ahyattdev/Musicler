//
//  iTunesResult.swift
//  Musicler
//
//  Created by Andrew Hyatt on 4/4/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Cocoa
import MP42Foundation

class iTunesResult {
    
    var track: Track
    var artist: Artist?
    var collection: Collection?
    
    var downloadedArtwork: NSImage?
    
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
    
    func writeMetadata(m4aFile: MP42File) {
        guard /*let artist = artist,*/ let collection = collection,
            let cover = downloadedArtwork else {
            print("\(track.trackName): Didn't fetch the rest of the metadata!")
            return
        }
        
        guard let art = MP42Image(image: cover) else {
            print("\(track.trackName): Couldn't convert artwork!")
            return
        }
        
        var metadata = [
            
            (MP42MetadataKeyName,
                         track.trackName as NSCopying & NSObjectProtocol,
                         MP42MetadataItemDataType.string),
            
            (MP42MetadataKeyArtist,
             track.artistName as NSCopying & NSObjectProtocol,
             MP42MetadataItemDataType.string),
            
            (MP42MetadataKeyAlbum,
             track.collectionName as NSCopying & NSObjectProtocol,
             MP42MetadataItemDataType.string),
            
            (MP42MetadataKeyDiscNumber,
             [track.discNumber, track.discCount] as NSCopying & NSObjectProtocol,
             MP42MetadataItemDataType.integerArray),
            
            (MP42MetadataKeyTrackNumber,
             [track.trackNumber, track.trackCount] as NSCopying & NSObjectProtocol,
             MP42MetadataItemDataType.integerArray),
            
            (MP42MetadataKeyReleaseDate,
             collection.releaseDate as NSCopying & NSObjectProtocol,
             MP42MetadataItemDataType.string),
            
            (MP42MetadataKeyCopyright,
             collection.copyright as NSCopying & NSObjectProtocol,
             MP42MetadataItemDataType.string),
            
            (MP42MetadataKeyAlbumArtist,
             collection.artistName as NSCopying & NSObjectProtocol,
             MP42MetadataItemDataType.string),
            (MP42MetadataKeyCoverArt,
             art,
             MP42MetadataItemDataType.image
             ),
        
        ]
        
        if let genre = track.primaryGenreName {
            metadata.append((MP42MetadataKeyUserGenre,
                             genre as NSCopying & NSObjectProtocol,
                             MP42MetadataItemDataType.string))
        }
        
        if track.trackExplicitness == "explicit" {
            metadata.append((MP42MetadataKeyContentRating,
                             1 as NSCopying & NSObjectProtocol,
                             .integer
                             ))
        }
        
        // Set compilation
        if collection.artistName == "Various Artists" {
            metadata.append((MP42MetadataKeyDiscCompilation,
                             1 as NSCopying & NSObjectProtocol,
                             .integer))
        }
        
        metadata.append((MP42MetadataKeyArtistID,
                         track.artistId as NSCopying & NSObjectProtocol,
                         .integer))
        
        // Remove previous artwork
        for item in m4aFile.metadata.items {
            if item.imageValue != nil {
                m4aFile.metadata.removeItem(item)
            }
        }
        
        for metadata in metadata {
            m4aFile.metadata.addItem(MP42MetadataItem(identifier: metadata.0, value: metadata.1, dataType: metadata.2, extendedLanguageTag: nil))
        }
        
        m4aFile.optimize()
        
        do {
            var options = [:] as [String : Any]
            options[MP42DontUpdateBitrate] = true
            try m4aFile.update(options: options)
        } catch {
            print("\(track.trackName): Failed to write to file. \(error)")
        }
    }
    
    func getDisplayData() -> [MetadataEntry] {
        var metadata = [MetadataEntry]()
        
        metadata.append(MetadataEntry(title: "Name", value: track.trackName))
        metadata.append(MetadataEntry(title: "Artist", value: track.artistName))
        if let collection = collection {
            metadata.append(MetadataEntry(title: "Album Artist", value: collection.artistName))
        }
        metadata.append(MetadataEntry(title: "Album", value: track.collectionName))
        metadata.append(MetadataEntry(title: "Genre", value: track.primaryGenreName ?? "No Genre"))
        metadata.append(MetadataEntry(title: "Release Date", value: track.releaseDate))
        metadata.append(MetadataEntry(title: "Track Number", value: "\(track.trackNumber) of \(track.trackCount)"))
        metadata.append(MetadataEntry(title: "Disc Number", value: "\(track.discNumber) of \(track.discCount)"))
        if let collection = collection {
            metadata.append(MetadataEntry(title: "Copyright", value: collection.copyright))
        }
        
        return metadata
    }
    

}
