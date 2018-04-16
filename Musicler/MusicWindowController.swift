//
//  MusicWindowController.swift
//  Musicler
//
//  Created by Andrew Hyatt on 4/15/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Cocoa

class MusicWindowController: NSWindowController {

    @IBOutlet weak var musicWindow: NSWindow!
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        let app = NSApp.delegate as! AppDelegate
        app.window = musicWindow
    }

}
