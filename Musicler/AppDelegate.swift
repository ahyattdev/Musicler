//
//  AppDelegate.swift
//  Musicler
//
//  Created by Andrew Hyatt on 2/15/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Cocoa
import MP42Foundation
import LetsMove

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var dropView: MusicDropViewController!
    
    weak var window: NSWindow!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        PFMoveToApplicationsFolderIfNecessary()
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
    
    func removeAllSortingData() {
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
                    
                    for path in paths {
                        let url = URL(fileURLWithPath: path)
                        do {
                            let file = try MP42File(url: url)
                            
                            var itemsToRemove = [MP42MetadataItem]()
                            
                            for item in file.metadata.items {
                                if item.identifier == MP42MetadataKeySortAlbum ||
                                    item.identifier == MP42MetadataKeySortArtist ||
                                    item.identifier == MP42MetadataKeySortName {
                                    itemsToRemove.append(item)
                                }
                            }
                            
                            file.metadata.removeItems(itemsToRemove)
                            for item in itemsToRemove {
                                file.metadata.removeItem(item)
                            }
                            var options = [:] as [String : Any]
                            options[MP42DontUpdateBitrate] = true
                            try file.update(options: options)
                        } catch {
                            print(error)
                        }
                    }
                    
                    
                }
            })
        }
    }
}
