//
//  Wrapper.swift
//  Musicler
//
//  Created by Andrew Hyatt on 4/4/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Foundation

struct Wrapper<T> : Codable where T : Codable {
    
    let resultCount: Int
    let results: [T]
    
}
