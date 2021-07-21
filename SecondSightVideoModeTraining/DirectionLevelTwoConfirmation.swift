//
//  DirectionLevelTwoConfirmation.swift
//  SecondSightVideoModeTraining
//
//  Created by Ping Sun on 7/27/20.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class DirectionLevelTwoConfirmation: UIViewController {
    
    @IBOutlet weak var DirectionDetectionGoBackButton: UIButton!
    @IBOutlet weak var DirectionDetectionConfirmButton: UIButton!
    
    let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: "You have selected level One. There will be one white rectangle that shifts left, right, up, down, or diagonally. Swipe in the same direction to get a point. If you would like to confirm, click anywhere on the right side of the screen. If you would like to return to the home page, click anywhere on the left side of the screen.")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func DirectionDetectionGoBack(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    @IBAction func DirectionDetectionConfirm(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
}
