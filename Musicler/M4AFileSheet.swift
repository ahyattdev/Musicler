//
//  M4AFileSheet.swift
//  Musicler
//
//  Created by Andrew Hyatt on 3/8/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Cocoa
import M4ATools
import os

class M4AFileSheet: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    var files: [String]!
    var m4aFiles = [String : M4AFile]()
    var fileIndex = 0
    var m4aFile: M4AFile!
    
    @IBOutlet weak var searchField: NSTextField!
    @IBOutlet weak var searchTableView: NSTableView!
    @IBOutlet weak var songTableView: NSTableView!
    
    var results = [iTunesResult]()
    
    var itunesSearcher = iTunesSearcher()
    
    @IBOutlet weak var trackTableView: NSTableView!
    @IBOutlet weak var resultsTableView: NSTableView!
    
    @IBOutlet weak var okButton: NSButton!
    
    @IBOutlet weak var leftButton: NSButton!
    @IBOutlet weak var rightButton: NSButton!
    
    override func viewWillAppear() {
        okButton.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        loadFile()
        
        if let fileName = m4aFile?.fileName {
            searchField.stringValue = fileName.replacingOccurrences(of:
                ".m4a", with: "")
        }
        
        leftButton.isEnabled = canShowPrevious()
        rightButton.isEnabled = canShowNext()
    }
    
    @IBAction func searchPressed(_ sender: NSButton) {
        itunesSearcher.trackName = searchField.stringValue
        results = itunesSearcher.search()
        resultsTableView.reloadData()
    }
    
    @IBAction func okPressed(_ sender: NSButton) {
        let row = resultsTableView.selectedRow
        if row > 0 {
            let selectedResult = results[resultsTableView.selectedRow]
            selectedResult.writeMetadata(m4aFile: m4aFile)
            dismissViewController(self)
        }
    }
    
    @IBAction func previousFile(_ sender: NSButton) {
        guard canShowPrevious() else {
            print("\(#function) called at an incorrect time")
            return
        }
        fileIndex -= 1
        loadFile()
        reset()
    }
    
    @IBAction func nextFile(_ sender: NSButton) {
        guard canShowNext() else {
            print("\(#function) called at an incorrect time")
            return
        }
        fileIndex += 1
        loadFile()
        reset()
    }
    
    func reset() {
        results.removeAll()
        resultsTableView.reloadData()
        songTableView.reloadData()
        if let fileName = m4aFile.fileName {
            searchField.stringValue = fileName.replacingOccurrences(of:
                ".m4a", with: "")
        }
        
        leftButton.isEnabled = canShowPrevious()
        rightButton.isEnabled = canShowNext()
    }
    
    func loadFile() {
        let filePath = files[fileIndex]
        if let file = m4aFiles[filePath] {
            m4aFile = file
        } else {
            let url = URL(fileURLWithPath: filePath)
            do {
                m4aFile = try M4AFile(url: url)
                m4aFiles[filePath] = m4aFile
            } catch {
                presentError(error)
            }
        }
    }
    
    func canShowPrevious() -> Bool {
        return fileIndex > 0
    }
    
    func canShowNext() -> Bool {
        return fileIndex < files.count - 1
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
    
    func tableView(_ tableView: NSTableView, shouldSelect tableColumn: NSTableColumn?) -> Bool {
        return false
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let table = notification.object as? NSTableView, table == resultsTableView {
            if resultsTableView.selectedRow > 0 {
                let result = results[resultsTableView.selectedRow]
                results[resultsTableView.selectedRow] = itunesSearcher.loadMoreMetadata(result: result)
            }
        }
    }
    
}
