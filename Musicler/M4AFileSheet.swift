//
//  M4AFileSheet.swift
//  Musicler
//
//  Created by Andrew Hyatt on 3/8/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Cocoa
import MP42Foundation

class M4AFileSheet: NSViewController, NSTableViewDelegate, NSTableViewDataSource, NSTextFieldDelegate {

    class EditorState {
        
        var path: String
        var file: MP42File
        var searchResults = [iTunesResult]()
        var searchText: String? = nil
        var selectedResult: iTunesResult? = nil
        var selectedRow: Int?
        
        init(path: String, file: MP42File) {
            self.path = path
            self.file = file
        }
        
    }
    
    var files: [String]!
    var fileIndex = 0
    
    var state: EditorState!
    var states = [String : EditorState]()
    
    @IBOutlet weak var searchField: NSTextField!
    @IBOutlet weak var searchTableView: NSTableView!
    
    var itunesSearcher: iTunesSearcher!
    
    @IBOutlet weak var metadataTableView: NSTableView!
    @IBOutlet weak var resultsTableView: NSTableView!
    
    @IBOutlet weak var okButton: NSButton!
    
    @IBOutlet weak var leftButton: NSButton!
    @IBOutlet weak var rightButton: NSButton!
    
    @IBOutlet weak var navLabel: NSTextField!
    
    @IBOutlet weak var artwork: NSImageView!
    
    var metadataDisplay = [iTunesResult.MetadataEntry]()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        itunesSearcher = iTunesSearcher(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
        loadFile()
        
        reset()
    }
    
    @IBAction func searchPressed(_ sender: NSButton) {
        search(completion: nil)
    }
    
    func search(completion: (() -> ())?) {
        itunesSearcher.trackName = searchField.stringValue
        itunesSearcher.search(completion: { (results) -> Void in
            self.state.searchResults = results
            self.resultsTableView.reloadData()
            if let completion = completion {
                completion()
            }
        })
    }
    
    @IBAction func okPressed(_ sender: NSButton) {
        for (_, state) in states {
            let result = state.selectedResult!
            result.writeMetadata(m4aFile: state.file)
        }
        dismiss(self)
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
        resultsTableView.reloadData()
        reloadDisplay()
        
        
        if state != nil {
            if state.searchText == nil {
                searchField.stringValue = fileSearchName()
                state.searchText = searchField.stringValue
                
            } else {
                searchField.stringValue = state.searchText!
            }
        }
        reloadButtons()
        
        navLabel.stringValue = "File \(fileIndex + 1) of \(files.count) (\(fileName()))"
        
        search(completion: {
            if self.state.searchResults.count > 0 {
                self.resultsTableView.selectRowIndexes(IndexSet(integersIn: 0 ..< 1), byExtendingSelection: false)
                
                if let row = self.state?.selectedRow {
                    self.resultsTableView.selectRowIndexes([row], byExtendingSelection: false)
                    
                    if let window = self.resultsTableView.window {
                        window.makeFirstResponder(self.resultsTableView)
                    }
                }
            }
        })
    }
    
    func loadFile() {
        let filePath = files[fileIndex]
        if let state = states[filePath] {
            self.state = state
        } else {
            let url = URL(fileURLWithPath: filePath)
            do {
                let m4aFile = try MP42File(url: url)
                m4aFile.recalculateBitrate = false
                
                let state = EditorState(path: filePath, file: m4aFile)
                states[filePath] = state
                self.state = state
                
            } catch {
                presentError(error)
                dismiss(self)
            }
        }
    }
    
    func canShowPrevious() -> Bool {
        return fileIndex > 0
    }
    
    func canShowNext() -> Bool {
        return fileIndex < files.count - 1 && state.selectedResult != nil
    }
    
    func canShowOK() -> Bool {
        // Check that every state has a selected result
        for (_, state) in states {
            if state.selectedResult == nil || state.selectedRow == nil {
                return false
            }
        }
        return files.count == states.count
    }
    
    func reloadButtons() {
        leftButton.isEnabled = canShowPrevious()
        rightButton.isEnabled = canShowNext()
        okButton.isEnabled = canShowOK()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == resultsTableView {
            return state.searchResults.count
        } else if tableView == metadataTableView {
            return metadataDisplay.count
        } else {
            return -1
        }
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if tableView == resultsTableView {
            let result = state.searchResults[row]
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
        } else if tableView == metadataTableView {
            let data = metadataDisplay[row]
            if tableColumn!.title == "Metadata" {
                return data.title
            } else {
                return data.value
            }
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if tableView == resultsTableView {
            itunesSearcher.loadMoreMetadata(result: state.searchResults[row], completion: {
                self.reloadDisplay()
            })
            state.selectedResult = state.searchResults[row]
            state.selectedRow = row
            reloadButtons()
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
            if resultsTableView.selectedRow >= 0 {
                state.selectedRow = resultsTableView.selectedRow
                let result = state.searchResults[resultsTableView.selectedRow]
                itunesSearcher.loadMoreMetadata(result: result, completion: {
                    self.reloadDisplay()
                })
                state.selectedResult = result
                reloadButtons()
            } else {
                state.selectedRow = nil
                state.selectedResult = nil
                reloadButtons()
                reloadDisplay()
            }
        }
    }
    
    func controlTextDidChange(_ obj: Notification) {
        guard let field = obj.object as? NSTextField else {
            return
        }
        
        if field == searchField {
            state.searchText = field.stringValue
        }
    }
    
    func reloadDisplay() {
        if let result = state.selectedResult {
            metadataDisplay = result.getDisplayData()
            artwork.image = result.downloadedArtwork
        } else {
            metadataDisplay.removeAll()
            artwork.image = nil
        }
        metadataTableView.reloadData()
    }
    
    func fileName() -> String {
        if let fileName = state?.file.url?.lastPathComponent {
            return fileName
        } else {
            return "Couldn't get filename"
        }
    }
    
    func fileSearchName() -> String {
        if let file = state?.file {
            var name = fileName()
            name = name.replacingOccurrences(of:
                ".m4a", with: "")
            if name.hasSuffix(".m4a") {
                name.removeSubrange(name.index(name.endIndex, offsetBy: ".m4a".count) ..< name.endIndex)
            }
            // 1-11 Another Rainy Night (Without You)
            let titles = file.metadata.metadataItemsFiltered(byIdentifier: MP42MetadataKeyName)
            let trackNumbers = file.metadata.metadataItemsFiltered(byIdentifier: MP42MetadataKeyTrackNumber)
            
            if titles.count == 1, let title = titles[0].stringValue {
                name = title
            } else if trackNumbers.count == 1 {
                let trackNumber = trackNumbers[0]
                if let track = trackNumber.arrayValue as? [Int], track.count == 2 {
                    let num = track[0]
                    var numString = num.description
                    if numString.utf8.count == 1 {
                        numString = "0".appending(numString)
                    }
                    numString = numString.appending(" ")
                    
                    if name.starts(with: numString) {
                        name.removeFirst(numString.count)
                    }
                }
            }
            return name
        } else {
            return ""
        }
    }
    
}
