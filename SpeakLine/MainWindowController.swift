//
//  MainWindowController.swift
//  SpeakLine
//
//  Created by MLS Discovery on 7/5/16.
//  Copyright © 2016 SoftwareSoFast. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    override var windowNibName: String {
        return "MainWindowController"
    }
    
    // MARK: - Outlets
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var speakButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!

    override func windowDidLoad() {
        super.windowDidLoad()

    }
    
    // MARK: - Action Methods
    @IBAction func speakIt(sender: NSButton) {
        // Get typed-in text as a string
        let string = textField.stringValue
        if string.isEmpty {
            print("stirng from \(textField!) is empty")
        } else {
            print("string is \"\(textField.stringValue)\"")
        }
    }
    
    @IBAction func stopIt(sender: NSButton) {
        print("stop button clicked")
    }
    
}
