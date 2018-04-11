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
    
    var results = [iTunesResult]()
    
    var itunesSearcher = iTunesSearcher()
    
    @IBOutlet weak var trackTableView: NSTableView!
    @IBOutlet weak var resultsTableView: NSTableView!
    
    @IBOutlet weak var okButton: NSButton!
    
    override func viewWillAppear() {
        okButton.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if let fileName = m4aFile.fileName {
            searchField.stringValue = fileName.replacingOccurrences(of:
                ".m4a", with: "")
        }
    }
    
    @IBAction func searchPressed(_ sender: NSButton) {
        itunesSearcher.trackName = searchField.stringValue
        results = itunesSearcher.search()
        resultsTableView.reloadData()
    }
    
    @IBAction func okPressed(_ sender: NSButton) {
        let selectedResult = results[resultsTableView.selectedRow]
        selectedResult.writeMetadata(m4aFile: m4aFile)
        dismissViewController(self)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == resultsTableView {
            return results.count
        } else {
            return -1
        }
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if tableView == resultsTableView {
            let result = results[row]
            switch tableColumn!.title {
            case "Track":
                var name = result.track.trackName
                if result.track.trackExplicitness == "explicit" {
                    name += " (E)"
                }
                return name
            case "Artist":
                return result.track.artistName
            case "Collection":
                return result.track.collectionName
            default:
                return "Unknown"
            }
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if tableView == resultsTableView {
            okButton.isEnabled = true
            return true
        } else {
            return true
        }
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let table = notification.object as? NSTableView, table == resultsTableView {
            let result = results[resultsTableView.selectedRow]
            results[resultsTableView.selectedRow] = itunesSearcher.loadMoreMetadata(result: result)
        }
    }
    
}
