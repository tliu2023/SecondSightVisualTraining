//
//  LevelTwoConfirmation.swift
//  Object localization game
//
//  Created by Ping Sun on 5/28/20.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import UIKit
import AVFoundation

class LevelTwoConfirmation: UIViewController {
    
    @IBOutlet weak var ConfirmButton: UIButton!
    @IBOutlet weak var MainMenuButton: UIButton!
    
    let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: "You have selected level two. There will be one 10 centimeter by 10 centimeter square that will appear for 20 seconds at a time. If you would like to confirm, click anywhere on the right side of the screen. If you would like to return to the home page, click anywhere on the left side of the screen. ")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
        
    }
    
    @IBAction func ConfirmAction(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    @IBAction func MainMenuAction(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
}
