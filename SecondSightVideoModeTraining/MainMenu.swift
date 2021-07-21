//
//  MainMenu.swift
//  SecondSightVideoModeTraining
//
//  Created by Ping Sun on 7/18/20.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class MainMenu: UIViewController {
    
    var newSquareSoundPlayer = AVAudioPlayer()
    let synthesizer = AVSpeechSynthesizer()
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?

    @IBOutlet weak var ObjectLocalizationButton: UIButton!
    @IBOutlet weak var ObjectLocalizationConfirmationButton: UIButton!

    @IBOutlet weak var MultiObjectLocalizationButton: UIButton!
    
    @IBOutlet weak var MultiObjectLocalizationConfirmationButton: UIButton!
    
    @IBOutlet weak var DirectionDetectionConfirmationButton: UIButton!
    @IBOutlet weak var DirectionDetectionButton: UIButton!
    
    @IBOutlet weak var PongButton: UIButton!
    @IBOutlet weak var PongConfirmationButton: UIButton!
    

    
    override func viewDidLoad() {
            super.viewDidLoad()
    
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func resetButtons() {
        ObjectLocalizationButton.isHidden = false
        ObjectLocalizationButton.isUserInteractionEnabled = true
        
        ObjectLocalizationConfirmationButton.isHidden = true
        ObjectLocalizationConfirmationButton.isUserInteractionEnabled = false

        MultiObjectLocalizationButton.isHidden = false
        MultiObjectLocalizationButton.isUserInteractionEnabled = true
        
        MultiObjectLocalizationConfirmationButton.isHidden = true
        MultiObjectLocalizationConfirmationButton.isUserInteractionEnabled = false
        
        DirectionDetectionButton.isHidden = false
        DirectionDetectionButton.isUserInteractionEnabled = true
        
        DirectionDetectionConfirmationButton.isHidden = true
        DirectionDetectionConfirmationButton.isUserInteractionEnabled = false
        
        PongButton.isHidden = false
        PongButton.isUserInteractionEnabled = true
        
        PongConfirmationButton.isHidden = true
        PongConfirmationButton.isUserInteractionEnabled = false
    }
    
    @IBAction func ObjectLocalization(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: "You have selected Object Localization. If you would like to continue, please tap the same place again. If you would like to choose a different game, please tap another place")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
        
        resetButtons()
        
        ObjectLocalizationButton.isHidden = true
        ObjectLocalizationButton.isUserInteractionEnabled = false
        
        ObjectLocalizationConfirmationButton.isHidden = false
        ObjectLocalizationConfirmationButton.isUserInteractionEnabled = true
    }
    
    @IBAction func ObjectLocalizationConfirmation(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
        resetButtons()
    }
    
    @IBAction func MultiObjectLocalization(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: "You have selected Multi Object Localization. If you would like to continue, please tap the same place again. If you would like to choose a different game, please tap another place")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
        
        resetButtons()
        
        MultiObjectLocalizationButton.isHidden = true
        MultiObjectLocalizationButton.isUserInteractionEnabled = false
        
        MultiObjectLocalizationConfirmationButton.isHidden = false
        MultiObjectLocalizationConfirmationButton.isUserInteractionEnabled = true
        
    }
    
    @IBAction func MultiObjectLocalizationConfirmation(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
        resetButtons()
    }
    
    
    @IBAction func DirectionDetection(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: "You have selected Direction Detection. If you would like to continue, please tap the same place again. If you would like to choose a different game, please tap another place")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
        resetButtons()
        
        DirectionDetectionButton.isHidden = true
        DirectionDetectionButton.isUserInteractionEnabled = false
        
        DirectionDetectionConfirmationButton.isHidden = false
        DirectionDetectionConfirmationButton.isUserInteractionEnabled = true
        
    }
    
    @IBAction func OrientationDetectionConfirmation(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
        resetButtons()
    }
    
    @IBAction func Pong(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: "You have selected Pong. If you would like to continue, please tap the same place again. If you would like to choose a different game, please tap another place")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
        resetButtons()
        
        PongButton.isHidden = true
        PongButton.isUserInteractionEnabled = false
        
        PongConfirmationButton.isHidden = false
        PongConfirmationButton.isUserInteractionEnabled = true
    }
    
    @IBAction func PongConfirmation(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
        resetButtons()
    }
}
