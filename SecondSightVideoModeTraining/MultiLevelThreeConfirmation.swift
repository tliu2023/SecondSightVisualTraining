//
//  MultiLevelThreeConfirmation.swift
//  SecondSightVideoModeTraining
//
//  Created by Ping Sun on 7/26/20.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class MultiLevelThreeConfirmation: UIViewController {
    
    @IBOutlet weak var MultiLevelThreeGoBackButton: UIButton!
    @IBOutlet weak var MultiLevelThreeConfirmButton: UIButton!
    
    let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: "You have selected level three. There will be two 5 centimeter by 5 centimeter square that will appear for 10 seconds at a time. If you would like to confirm, click anywhere on the right side of the screen. If you would like to return to the home page, click anywhere on the left side of the screen. ")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func MultiLevelThreeGoBack(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    @IBAction func MultiLevelThreeConfirm(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
}
