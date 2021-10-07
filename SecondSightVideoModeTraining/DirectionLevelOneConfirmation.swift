//
//  DirectionLevelOneConfirmation.swift
//  SecondSightVideoModeTraining
//
//  Created by Tony Liu on 7/27/20.
//

import UIKit
import AVFoundation
import Speech

class DirectionLevelOneConfirmation: UIViewController {
    
    @IBOutlet weak var DirectionDetectionGoBackButton: UIButton!
    @IBOutlet weak var DirectionDetectionConfirmButton: UIButton!
    
    let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: "You have selected level One. There will be one white rectangle that shifts left, right, up, or down. Swipe in the same direction to get a point. If you would like to confirm, click anywhere on the right side of the screen. If you would like to return to the home page, click anywhere on the left side of the screen. ")
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
