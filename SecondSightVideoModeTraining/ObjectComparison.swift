//
//  ObjectComparison.swift
//  SecondSightVideoModeTraining
//
//  Created by Ping Sun on 8/18/20.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class ObjectComparison: UIViewController {
    
    @IBOutlet weak var Level1Button: UIButton!
    @IBOutlet weak var Level2Button: UIButton!
    @IBOutlet weak var Level3Button: UIButton!
    
    var newSquareSoundPlayer = AVAudioPlayer()
    let synthesizer = AVSpeechSynthesizer()
    let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: "Please select the type of the game. The left square is size. The middle square is shape. The right square is contrast.")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    @IBAction func LevelOne(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    @IBAction func LevelTwo(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    @IBAction func LevelThree(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
