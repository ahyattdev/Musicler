//
//  MusicDropViewController.swift
//  Musicler
//
//  Created by Andrew Hyatt on 3/8/18.
//  Copyright © 2018 Andrew Hyatt. All rights reserved.
//

import Cocoa
import M4ATools

class MusicDropViewController: NSViewController {
    
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
            let m4aFile = sender as! M4AFile
            
            let sheet = segue.destinationController as! M4AFileSheet
            sheet.m4aFile = m4aFile
        }
    }
    
}
