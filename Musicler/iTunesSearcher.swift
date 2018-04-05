//
//  iTunesSearcher.swift
//  Musicler
//
//  Created by Andrew Hyatt on 3/8/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Foundation

class iTunesSearcher {
    
    static func search(trackName: String) -> [iTunesResult] {
        var results = [iTunesResult]()
        guard let escaped = trackName.addingPercentEncoding(
            withAllowedCharacters: []),
            let url = URL(string:
                "https://itunes.apple.com/search?term=\(escaped)&country=us&media=music&entity=song")
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
            print("Failed to decode JSON!")
        }
        return results
    }
    
    func loadMoreMetadata(result: iTunesResult) {
        
    }
    
}
