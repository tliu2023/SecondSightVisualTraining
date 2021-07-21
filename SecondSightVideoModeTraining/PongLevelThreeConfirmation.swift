//
//  PongLevelThreeConfirmation.swift
//  SecondSightVideoModeTraining
//
//  Created by Ping Sun on 8/11/20.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class PongLevelThreeConfirmation: UIViewController {
    
    @IBOutlet weak var PongGoBackButton: UIButton!
    @IBOutlet weak var PongConfirmButton: UIButton!
    
    let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: "You have selected level three. There will be one 90 by 90 circle moving at slow speeds. If you would like to confirm, click anywhere on the right side of the screen. If you would like to return to the home page, click anywhere on the left side of the screen. ")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func PongGoBack(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    @IBAction func PongConfirm(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
}
