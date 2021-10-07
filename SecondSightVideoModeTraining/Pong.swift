//
//  Pong.swift
//  SecondSightVideoModeTraining
//
//  Created by Tony Liu on 8/11/20.
//

import UIKit
import AVFoundation
import Speech


class Pong: UIViewController {
    
    @IBOutlet weak var EasyButton: UIButton!
    @IBOutlet weak var MediumButton: UIButton!
    @IBOutlet weak var HardButton: UIButton!
    
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
