//
//  AppDelegate.swift
//  Musicler
//
//  Created by Andrew Hyatt on 2/15/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Cocoa
import M4ATools

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var dropView: MusicDropViewController!
    
    weak var window: NSWindow!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        dropView.dropView.openFiles(filenames)
    }
    
    @IBAction func openMenu(_ sender: NSMenuItem) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = true
        panel.allowedFileTypes = ["m4a"]
        
        if let window = window {
            panel.beginSheetModal(for: window, completionHandler: { response in
                if response == NSApplication.ModalResponse.OK {
                    var paths = [String]()
                    for url in panel.urls {
                        paths.append(url.path)
                    }
                    self.dropView.dropView.openFiles(paths)
                }
            })
        }
    }
}
