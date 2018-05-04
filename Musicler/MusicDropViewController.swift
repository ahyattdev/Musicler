//
//  MusicDropViewController.swift
//  Musicler
//
//  Created by Andrew Hyatt on 3/8/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Cocoa
import MP42Foundation

class MusicDropViewController: NSViewController {
    
    @IBOutlet var dropView: MusicDropView!
    
    struct Segues {
        
        private init() {
            
        }
        
        static let M4AFileSheet =
            NSStoryboardSegue.Identifier(rawValue: "M4AFileSheet")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        (NSApp.delegate as! AppDelegate).dropView = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, id == Segues.M4AFileSheet {
            let files = sender as! [String]
            
            let sheet = segue.destinationController as! M4AFileSheet
            sheet.files = files
        }
    }
    
    @IBAction func open(_ sender: Any) {
        let appDelegate = NSApp.delegate as! AppDelegate
        
        if NSEvent.modifierFlags.contains(.option) {
            appDelegate.removeAllSortingData()
        } else {
            appDelegate.openMenu(NSMenuItem())
        }
    }
}
