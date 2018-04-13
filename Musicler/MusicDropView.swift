//
//  MusicDropView.swift
//  Musicler
//
//  Created by Andrew Hyatt on 3/8/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Cocoa
import M4ATools

class MusicDropView: NSView {

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        registerForDraggedTypes([.fileURL])
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return [.copy]
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let sourceDragMask = sender.draggingSourceOperationMask()
        
        let pasteboard = sender.draggingPasteboard()
        
        if let types = pasteboard.types {
            if types.contains(.fileURL) &&
                sourceDragMask.contains(NSDragOperation.copy) {
                if let files = pasteboard.propertyList(forType:
                    NSPasteboard.PasteboardType(rawValue:
                        "NSFilenamesPboardType")) as? NSArray {
                    for file in files {
                        if let string = file as? String,
                            string.lowercased().hasSuffix(".m4a") {
                            let url = URL(fileURLWithPath: string)
                            do {
                                let m4aFile = try M4AFile(url: url)
                                let app = NSApp.delegate as! AppDelegate
                                app.dropView.performSegue(withIdentifier:
                                    MusicDropViewController.Segues.M4AFileSheet,
                                                          sender: m4aFile)
                            } catch {
                                
                            }
                        }
                    }
                }
                
            }
            

        }
        
        return true
    }
    
    func openFiles(_ filenames: [String]) {
        for file in filenames {
            let url = URL(fileURLWithPath: file)
            do {
                let m4aFile = try M4AFile(url: url)
                let app = NSApp.delegate as! AppDelegate
                app.dropView.performSegue(withIdentifier:
                    MusicDropViewController.Segues.M4AFileSheet,
                                          sender: m4aFile)
            } catch {
                printView("Error opening M4A file: \(error)")
            }
            
        }
    }

}
