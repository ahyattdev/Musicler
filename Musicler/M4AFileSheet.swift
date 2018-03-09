//
//  M4AFileSheet.swift
//  Musicler
//
//  Created by Andrew Hyatt on 3/8/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Cocoa
import M4ATools

class M4AFileSheet: NSViewController {

    var m4aFile: M4AFile!
    
    @IBOutlet weak var searchField: NSTextField!
    @IBOutlet weak var searchTableView: NSTableView!
    @IBOutlet weak var songTableView: NSTableView!
    
    var selectedResult: Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if let fileName = m4aFile.fileName {
            searchField.stringValue = fileName.replacingOccurrences(of:
                ".m4a", with: "")
        }
    }
    
    @IBAction func searchPressed(_ sender: NSButton) {
        let search = searchField.stringValue
        let results = iTunesSearcher.search(trackName: search)
        selectedResult = songs[0]
    }
    
}
