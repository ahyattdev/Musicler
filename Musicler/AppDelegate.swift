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
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func handleM4AFile(_ path: String) {
        let url = URL(fileURLWithPath: path)
        var m4aFile: M4AFile!
        var m4aWindow: NSWindow!
        
        do {
            m4aFile = try M4AFile(url: url)
        } catch {
            
        }
        
    }

}
