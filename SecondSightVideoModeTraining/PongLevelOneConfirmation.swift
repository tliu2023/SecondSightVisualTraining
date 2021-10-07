//
//  PongLevelOneConfirmation.swift
//  SecondSightVideoModeTraining
//
//  Created by Tony Liu on 8/11/20.
//

import UIKit
import AVFoundation
import Speech

class PongLevelOneConfirmation: UIViewController {
    
    @IBOutlet weak var PongGoBackButton: UIButton!
    @IBOutlet weak var PongConfirmButton: UIButton!
    
    let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: "You have selected level One. There will be one 90 by 90 circle moving at slow speeds. If you would like to confirm, click anywhere on the right side of the screen. If you would like to return to the home page, click anywhere on the left side of the screen. ")
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
