//
//  iTunesSearcher.swift
//  Musicler
//
//  Created by Andrew Hyatt on 3/8/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Cocoa

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
    
    private var viewController: NSViewController
    init(viewController: NSViewController) {
        self.viewController = viewController
    }
    
    func search(completion: @escaping (_ results: [iTunesResult]) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            var results = [iTunesResult]()
            guard let url = URL(string:
                "https://itunes.apple.com/search?term=\(self.escapedName)&country=us&media=music&entity=song")
                else {
                    DispatchQueue.main.async {
                        completion(results)
                    }
                    return
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
                DispatchQueue.main.async {
                    self.viewController.presentError(error)
                }
                
            }
            DispatchQueue.main.async {
                completion(results)
            }
        }
    }
    
    func loadMoreMetadata(result: iTunesResult, completion: @escaping () -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            if result.collection == nil {
                guard let collectionURL = URL(string: "https://itunes.apple.com/lookup?id=\(result.track.collectionId)") else {
                    print("Failed to load collection URL")
                    return
                }
                
                do {
                    let data = try Data.init(contentsOf: collectionURL)
                    let json = try JSONDecoder().decode(Wrapper<Collection>.self, from: data)
                    
                    if json.results.count == 1 {
                        result.collection = json.results[0]
                    } else {
                        throw NSError(domain: "io.github.ahyattdev.Musicler.ErrorDomain", code: 5, userInfo: [NSLocalizedDescriptionKey : "Too many results for collection"])
                    }
                    
                    // Get artwork
                    guard let artworkURL = URL(string: result.collection!.artworkUrl100.absoluteString.replacingOccurrences(of: "100x100bb.jpg", with: "600x600bb.jpg")) else {
                        throw NSError(domain: "io.github.ahyattdev.Musicler.ErrorDomain", code: 5, userInfo: [NSLocalizedDescriptionKey : "Couldn't get artwork URL"])
                    }
                    
                    result.downloadedArtwork = NSImage.init(contentsOf: artworkURL)
                    DispatchQueue.main.async {
                        completion()
                    }
                } catch {
                    print("Failed to decode JSON! \(error)")
                    self.viewController.presentError(error)
                }
            } else {
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
}
