//
//  iTunesSearcher.swift
//  Musicler
//
//  Created by Andrew Hyatt on 3/8/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Foundation
import SwiftyJSON

class iTunesSearcher {
    
    static func search(trackName: String) -> [Song] {
        var results = [Song]()
        guard let escaped = trackName.addingPercentEncoding(
            withAllowedCharacters: []),
            let url = URL(string:
                "https://itunes.apple.com/search?term=\(escaped)&country=us")
            else {
            return results
        }
        
        
        do {
            let data = try Data.init(contentsOf: url)
            let json = try JSON.init(data: data)
            let jsonResults = json["results"].arrayValue
            for songJSON in jsonResults {
                if let song = Song(json: songJSON.dictionaryValue) {
                    results.append(song)
                }
            }
        } catch {
            
        }
        return results
    }
    
}
