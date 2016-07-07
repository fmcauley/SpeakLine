//
//  MainWindowController.swift
//  SpeakLine
//
//  Created by MLS Discovery on 7/5/16.
//  Copyright © 2016 SoftwareSoFast. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSSpeechSynthesizerDelegate, NSWindowDelegate {
    override var windowNibName: String {
        return "MainWindowController"
    }
    
    // MARK: - Outlets
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var speakButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    
    let speechSynth = NSSpeechSynthesizer()
    
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
    
    // MARK: - NSSpeechSynthesizerDelegate
    func speechSynthesizer(_ sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        self.isStarted = false
    }
    
    // MARK: - NSWindowDelegate
    func windowShouldClose(_ sender: AnyObject) -> Bool {
        return isStarted
    }
    
    /**Being a delegate 
     
     The first thing to understand about being a delegate is that it is a role – possibly one of many – that an object may take on. In Cocoa, roles are defined by protocols. The specific role of “delegate that serves a speech synthesizer” is defined by the NSSpeechSynthesizerDelegate protocol. To sign up for this role, an object must be an instance of a class that conforms to the NSSpeechSynthesizerDelegate protocol. 
     
    The beauty of having delegate roles defined by protocols (delegation) instead of classes (subclassing) is that any object whose type conforms to the protocol can serve in that capacity. Thus, you can assign critical duties without associating them with any particular object class. Moreover, an object can take on multiple roles as needed.
     
     This is an example of a second type of delegate method – one where the delegate can directly affect the behavior of the object as opposed to being passively informed of events.
     
     Some delegate proerties can be set in code or in the XIB. the NSWindowDelegate is already set for us in the XIB file
     
     Delegate methods that use Notifications
     
     */
    
}
