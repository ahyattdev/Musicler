//
//  MusicDropView.swift
//  Musicler
//
//  Created by Andrew Hyatt on 3/8/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Cocoa

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
                if let files = pasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray {
                    for file in files {
                        if let string = file as? String {
                            if string.lowercased().hasSuffix(".m4a") {
                                (NSApplication.shared.delegate as! AppDelegate).handleM4AFile(string)
                            }
                        }
                    }
                }
                
            }
        }
        
        return true
    }

}
