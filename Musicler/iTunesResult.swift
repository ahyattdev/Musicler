//
//  iTunesResult.swift
//  Musicler
//
//  Created by Andrew Hyatt on 4/4/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Foundation

struct iTunesResult {
    
    var track: Track
    var artist: Artist?
    var collection: Collection?
    
    init(track: Track) {
        self.track = track
    }
    
}
