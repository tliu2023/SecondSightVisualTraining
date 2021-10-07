//
//  LevelThreeConfirmation.swift
//  Object localization game
//
//  Created by Tony Liu on 5/28/20.
//

import UIKit
import AVFoundation

class LevelThreeConfirmation: UIViewController {
    
    @IBOutlet weak var LevelThreeGoBackButton: UIButton!
    @IBOutlet weak var LevelThreeConfirmButton: UIButton!
    
    
    let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: "You have selected level three. There will be one 5 centimeter by 5 centimeter square that will appear for 20 seconds at a time. If you would like to confirm, click anywhere on the right side of the screen. If you would like to return to the home page, click anywhere on the left side of the screen. ")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
    
    @IBAction func LevelThreeGoBack(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    @IBAction func LevelThreeConfirm(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
}
