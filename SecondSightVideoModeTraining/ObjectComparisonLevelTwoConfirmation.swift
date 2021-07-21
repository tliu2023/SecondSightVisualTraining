//
//  ObjectComparisonLevelTwoConfirmation.swift
//  SecondSightVideoModeTraining
//
//  Created by Ping Sun on 8/18/20.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class ObjectComparisonLevelTwoConfirmation: UIViewController {
    
    @IBOutlet weak var ObjectComparisonGoBackButton: UIButton!
    @IBOutlet weak var ObjectComparisonConfirmButton: UIButton!
    
    let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: "You have selected shape. There will be two 10 centimeter by 10 centimeter squares that will each appear for 20 seconds at a time. Tapping on the correct square will cause it to disappear. If you would like to confirm, click anywhere on the right side of the screen. If you would like to return to the home page, click anywhere on the left side of the screen. ")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ObjectComparisonLevelTwoGoBack(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    @IBAction func ObjectComparisonLevelTwoConfirm(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
}
