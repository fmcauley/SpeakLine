//
//  MainWindowController.swift
//  SpeakLine
//
//  Created by MLS Discovery on 7/5/16.
//  Copyright © 2016 SoftwareSoFast. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSSpeechSynthesizerDelegate, NSWindowDelegate, NSTableViewDataSource, NSTableViewDelegate {
    override var windowNibName: String {
        return "MainWindowController"
    }
    
    // MARK: - Outlets
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var speakButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    let speechSynth = NSSpeechSynthesizer()
    let voices  = NSSpeechSynthesizer.availableVoices()
    
    var voiceTableViewDelegate: VoiceTableViewDelegate!
    
    /**didSet and willSet are observers that you can declare as part of a stored property. Implementing observers allows you to respond to the property’s value being changed.
     */
    
    var isStarted: Bool = false {
        didSet {
            updateButtons()
        }
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        self.updateButtons()
        speechSynth.delegate = self
        
        let defaultVoice = NSSpeechSynthesizer.defaultVoice()
        if let defaultRow = voices.index(of: defaultVoice) {
            let indices = NSIndexSet(index: defaultRow)
            // how to convert or use IndexSet?
        
            tableView.selectRowIndexes(indices as IndexSet, byExtendingSelection: false)
            tableView.scrollRowToVisible(defaultRow)
        }
        
        self.voiceTableViewDelegate = VoiceTableViewDelegate(tableView: self.tableView, data: voices,speechSyn:speechSynth)
        self.tableView.delegate = self.voiceTableViewDelegate
        
    }
    
    // MARK: - Action Methods
    @IBAction func speakIt(sender: NSButton) {
        // Get typed-in text as a string
        let string = textField.stringValue
        if string.isEmpty {
            print("stirng from \(textField!) is empty")
        } else {
            speechSynth.startSpeaking(string)
            isStarted = true
        }
    }
    
    @IBAction func stopIt(sender: NSButton) {
        speechSynth.stopSpeaking()
    }
    
    func updateButtons() {
        if isStarted {
            speakButton.isEnabled = false
            stopButton.isEnabled = true
        } else {
            stopButton.isEnabled = false
            speakButton.isEnabled = true
        }
    }
    
    func voiceNameForIdentifier(identifier: String) -> String? {
        let attributes = NSSpeechSynthesizer.attributes(forVoice: identifier)
        return attributes[NSVoiceName] as? String
    }
    
    // MARK: - NSSpeechSynthesizerDelegate
    func speechSynthesizer(_ sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        self.isStarted = false
    }
    
    // MARK: - NSWindowDelegate
    func windowShouldClose(_ sender: AnyObject) -> Bool {
        return isStarted
    }
    
    // MARK: - NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        return voices.count
    }
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        let voice = voices[row]
        let voiceName = voiceNameForIdentifier(identifier: voice)
        return voiceName
    }
}

    class VoiceTableViewDelegate: NSObject, NSTableViewDelegate {
        
        var tableView: NSTableView!
        var speechSynth: NSSpeechSynthesizer!
        var voices: [String]!
        
        init(tableView: NSTableView, data: [String], speechSyn: NSSpeechSynthesizer) {
            super.init()
            self.speechSynth = speechSyn
            self.tableView = tableView
            self.voices = data
            
        }
        
        // MARK: - NSTableViewDelegate
        func tableViewSelectionDidChange(_ notification: Notification) {
                        let row = tableView.selectedRow
                        if row == -1 {
                            speechSynth.setVoice(nil)
                            return
                        }
                        let voice = voices[row]
                        speechSynth.setVoice(voice)
        }
            
}

// MARK: - NOTES

/**Being a delegate
 
 The first thing to understand about being a delegate is that it is a role – possibly one of many – that an object may take on. In Cocoa, roles are defined by protocols. The specific role of “delegate that serves a speech synthesizer” is defined by the NSSpeechSynthesizerDelegate protocol. To sign up for this role, an object must be an instance of a class that conforms to the NSSpeechSynthesizerDelegate protocol.
 
 The beauty of having delegate roles defined by protocols (delegation) instead of classes (subclassing) is that any object whose type conforms to the protocol can serve in that capacity. Thus, you can assign critical duties without associating them with any particular object class. Moreover, an object can take on multiple roles as needed.
 
 This is an example of a second type of delegate method – one where the delegate can directly affect the behavior of the object as opposed to being passively informed of events.
 
 Some delegate proerties can be set in code or in the XIB. the NSWindowDelegate is already set for us in the XIB file
 
 Delegate methods that use Notifications
 
 */
