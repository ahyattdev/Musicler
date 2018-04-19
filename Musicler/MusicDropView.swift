//
//  MusicDropView.swift
//  Musicler
//
//  Created by Andrew Hyatt on 3/8/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Cocoa
import MP42Foundation

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
                        "NSFilenamesPboardType")) as? [String] {
                    let app = NSApp.delegate as! AppDelegate
                    app.dropView.performSegue(withIdentifier: MusicDropViewController.Segues.M4AFileSheet, sender: files)
                }
                
            }
            

        }
        
        return true
    }
    
    func openFiles(_ filenames: [String]) {
        let app = NSApp.delegate as! AppDelegate
        app.dropView.performSegue(withIdentifier:
            MusicDropViewController.Segues.M4AFileSheet,
                                  sender: filenames)
    }

}
