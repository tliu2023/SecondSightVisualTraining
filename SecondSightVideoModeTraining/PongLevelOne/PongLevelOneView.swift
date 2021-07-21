//
//  GameViewController.swift
//  PongLevelOne
//
//  Created by Ping Sun on 8/3/20.
//  Copyright © 2020 Tony Liu. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
import Speech

class PongLevelOneView
: UIViewController {
    
    // UI Objects
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var ScoreButton: UIButton!
    @IBOutlet weak var RecordButton: UIButton!
    @IBOutlet weak var StopRecordButton: UIButton!
    @IBOutlet weak var ExitButton: UIButton!
    @IBOutlet weak var ConfirmExitButton: UIButton!
    @IBOutlet weak var FreeGazingButton: UIButton!
    @IBOutlet weak var FixationButton: UIButton!
    
    @IBOutlet weak var HiddenView: UIView!
    @IBOutlet weak var StartBackground: UIView!
    
    // TextFile Title Information
    let date = Date()
    let formatter = DateFormatter()
    var currentDate = ""
    var currentTrial = 1
    var trialStatus = ""
    
    // Tracked Data
    
    // TextFile Data
    var trial = 0
    var direction = ""
    var beginX = 0.0
    var endX = 0.0
    var beginY = 0.0
    var endY = 0.0
    var currentStatus = ""
    
    // Audio Variables
    var bestString = ""
    
    var newSquareSoundPlayer = AVAudioPlayer()
    let synthesizer = AVSpeechSynthesizer()
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        synthesizer.stopSpeaking(at: .immediate)
        HiddenView.isHidden = true
        ConfirmExitButton.isHidden = true
        
        let utterance = AVSpeechUtterance(string: "Press the start button in the middle whenever you are ready to begin." )
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
        
    }
    
    @IBAction func FreeGazing(_ sender: UIButton) {
        trialStatus = "FG"
        FixationButton.isHidden = true
        FreeGazingButton.isHidden = true
        
        FixationButton.isUserInteractionEnabled = false
        FreeGazingButton.isUserInteractionEnabled = false
        
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: "You have selected Free Gazing. Press the start button in the middle whenever you are ready to begin." )
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
    
    @IBAction func Fixation(_ sender: UIButton) {
        trialStatus = "F"
        FixationButton.isHidden = true
        FreeGazingButton.isHidden = true
        
        FixationButton.isUserInteractionEnabled = false
        FreeGazingButton.isUserInteractionEnabled = false
        
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: "You have selected Fixation. Please keep your eye on the focus point. Press the start button in the middle whenever you are ready to begin." )
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
    
    @IBAction func StartButton(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
        StartButton.isHidden = true
        
        ConfirmExitButton.isHidden = true
        ConfirmExitButton.isUserInteractionEnabled = false
        StopRecordButton.isHidden = true
        StopRecordButton.isUserInteractionEnabled = false
        ExitButton.isHidden = false
        HiddenView.isHidden = false
        StartBackground.isHidden = true
        
        
        if let scene = SKScene(fileNamed:"PongLevelOne") {
            let skView = self.view as! SKView
            //setup your scene here
            skView.presentScene(scene)
        }
    }
    
    @IBAction func giveScore(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
        
        let levelOneAttempts = attempts
        let levelOneMainScore = mainScore
        
        
        
        let utterance = AVSpeechUtterance(string: "Your current score is " + String(levelOneMainScore) + "out of " + String(levelOneAttempts) + "bounces")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        self.synthesizer.speak(utterance)
    }
    
    @IBAction func beginExit(_ sender: UIButton) {
        
        synthesizer.stopSpeaking(at: .immediate)
        ConfirmExitButton.isHidden = false
        ConfirmExitButton.isUserInteractionEnabled = true
        ExitButton.isHidden = true
        
        let utterance = AVSpeechUtterance(string: "You have pressed the exit button. If you are sure, please press the button again. If you would like to continue, press the resume button in the middle of the screen.")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        self.synthesizer.speak(utterance)
    }
    
    @IBAction func confirmExit(_ sender: UIButton) {
        
        let levelOneAttempts = attempts
        let levelOneMainScore = mainScore
        
        synthesizer.stopSpeaking(at: .immediate)
        
        let utterance = AVSpeechUtterance(string: "Your final score was " + String(levelOneMainScore) + "out of " + String(levelOneAttempts) + "bounces. Thank you for playing.")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        self.synthesizer.speak(utterance)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func beginRecord(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
        RecordButton.isHidden = true
        RecordButton.isUserInteractionEnabled = false
        StopRecordButton.isHidden = false
        StopRecordButton.isUserInteractionEnabled = true
        
        recordAndRecognizeSpeech()
    }
    
    @IBAction func stopRecord(_ sender: UIButton) {
        RecordButton.isHidden = false
        RecordButton.isUserInteractionEnabled = true
        StopRecordButton.isHidden = true
        StopRecordButton.isUserInteractionEnabled = false
        
        let levelOneAttempts = attempts
        let levelOneMainScore = mainScore
        
        if bestString.lowercased().contains("stop"){
            
            let utterance = AVSpeechUtterance(string: "Your final score was " + String(levelOneMainScore) + "out of " + String(levelOneAttempts) + "bounces. Thank you for playing.")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.5
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
        }
        if bestString.lowercased().contains("score"){
            self.synthesizer.stopSpeaking(at: .immediate)
            let utterance = AVSpeechUtterance(string: "Your current score is " + String(levelOneMainScore) + "out of " + String(levelOneAttempts) + "squares")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.5
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
        }
        bestString = ""
        audioEngine.stop()
        request.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    func recordAndRecognizeSpeech(){
        do { try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, options: .mixWithOthers)
        }catch{
            print("error")
        }
        let node = audioEngine.inputNode
        let recordingFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)
        
        if(node.inputFormat(forBus: 0).channelCount == 0){
            NSLog("Not enough available inputs!")
            return
        }
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            buffer, _ in self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                self.audioEngine.inputNode.removeTap(onBus: 0)
                self.recognitionTask?.finish()
            }
        } catch {
            return print(error)
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else {
            return
        }
        if !myRecognizer.isAvailable{
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: {result, error in
            if let result = result {
                self.bestString = result.bestTranscription.formattedString
                print(self.bestString)
            }else if let error = error {
                print (error)
            }
        })
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
