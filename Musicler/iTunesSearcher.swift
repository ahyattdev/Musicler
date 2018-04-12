//
//  iTunesSearcher.swift
//  Musicler
//
//  Created by Andrew Hyatt on 3/8/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Foundation

class iTunesSearcher {
    
    var trackName = "" {
        didSet {
            guard let escapedName = trackName.addingPercentEncoding(
                withAllowedCharacters: []) else {
                    self.escapedName = "error"
                    return
            }
            self.escapedName = escapedName
        }
    }
    
    private var escapedName = ""
    
    func search() -> [iTunesResult] {
        var results = [iTunesResult]()
        guard let url = URL(string:
                "https://itunes.apple.com/search?term=\(escapedName)&country=us&media=music&entity=song")
            else {
            return results
        }
        
        
        do {
            let data = try Data.init(contentsOf: url)
            
            let json = try JSONDecoder().decode(Wrapper<Track>.self, from: data)
            
            for track in json.results {
                let result = iTunesResult(track: track)
                results.append(result)
            }
        } catch {
            print("Failed to decode JSON! \(error)")
        }
        return results
    }
    
    func loadMoreMetadata(result: iTunesResult) -> iTunesResult {
        var result = result
        if result.collection == nil {
            guard let collectionURL = URL(string: "https://itunes.apple.com/lookup?id=\(result.track.collectionId)") else {
                print("Failed to load collection URL")
                return result
            }
            do {
                let data = try Data.init(contentsOf: collectionURL)
                let json = try JSONDecoder().decode(Wrapper<Collection>.self, from: data)
                
                if json.results.count == 1 {
                    result.collection = json.results[0]
                }
            } catch {
                print("Failed to decode JSON! \(error)")
            }
        }
        return result
    }
    
}
