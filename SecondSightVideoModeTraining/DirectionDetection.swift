//
//  LevelOne.swift
//  Object localization game
//
//  Created by Tony Liu on 5/29/20.
//

import UIKit
import AVFoundation
import Speech

class DirectionDetection: UIViewController {
    
    @IBOutlet weak var Level1Button: UIButton!
    @IBOutlet weak var Level2Button: UIButton!
    @IBOutlet weak var Level3Button: UIButton!
    
    var newSquareSoundPlayer = AVAudioPlayer()
    let synthesizer = AVSpeechSynthesizer()
    let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: "Please select the difficulty of the game. The left square is easy. The middle square is medium. The right square is hard.")
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
