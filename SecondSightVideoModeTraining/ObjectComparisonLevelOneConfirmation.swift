//
//  ObjectComparisonLevelOneConfirmation.swift
//  SecondSightVideoModeTraining
//
//  Created by Tony Liu on 8/18/20.
//

import UIKit
import AVFoundation
import Speech

class ObjectComparisonLevelOneConfirmation: UIViewController {
    
    @IBOutlet weak var ObjectComparisonGoBackButton: UIButton!
    @IBOutlet weak var ObjectComparisonConfirmButton: UIButton!
    
    let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: "You have selected size. There will be two objects that will each appear for 20 seconds at a time with an instruction. Tapping on the correct object will give you a point. If you would like to confirm, click anywhere on the right side of the screen. If you would like to return to the home page, click anywhere on the left side of the screen. ")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ObjectComparisonLevelOneGoBack(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    @IBAction func ObjectComparisonLevelOneConfirm(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
}
