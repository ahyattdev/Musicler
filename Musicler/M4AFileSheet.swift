//
//  M4AFileSheet.swift
//  Musicler
//
//  Created by Andrew Hyatt on 3/8/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Cocoa
import M4ATools

class M4AFileSheet: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    var m4aFile: M4AFile!
    
    @IBOutlet weak var searchField: NSTextField!
    @IBOutlet weak var searchTableView: NSTableView!
    @IBOutlet weak var songTableView: NSTableView!
    
    var selectedResult: iTunesResult?
    var results = [iTunesResult]()
    
    @IBOutlet weak var trackTableView: NSTableView!
    @IBOutlet weak var resultsTableView: NSTableView!
    
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
        results = iTunesSearcher.search(trackName: search)
        if results.count > 0 {
            selectedResult = results[0]
        }
        resultsTableView.reloadData()
        //selectedResult!.fetchAll()
        //selectedResult!.writeMetadata(m4aFile: m4aFile)
    }
    
    @IBAction func okPressed(_ sender: NSButton) {
       // if let song = selectedResult {
            //song.writeMetadata(m4aFile: m4aFile)
       // }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == resultsTableView {
            return results.count
        } else {
            return -1
        }
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let result = results[row]
        switch tableColumn!.title {
        case "Track":
            if let name = result.track.trackName {
                return name
            }
        case "Artist":
            return result.track.artistName
        case "Collection":
            if let name = result.track.collectionName {
                return name
            }
        default:
            return "Unknown"
        }
        return result.track.trackName!
    }
    
}
