//
//  LevelThree.swift
//  Object localization game
//
//  Created by Tony Liu on 5/29/20.
//

import UIKit
import AVFoundation
import Speech

class LevelThree: UIViewController {
    
    // UI Objects
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var ScoreButton: UIButton!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var ExitButton: UIButton!
    @IBOutlet weak var ConfirmExitButton: UIButton!
    @IBOutlet weak var FreeGazingButton: UIButton!
    @IBOutlet weak var FixationButton: UIButton!
    
    @IBOutlet weak var PlayingView: UIView!
    @IBOutlet weak var HiddenView: UIView!
    
    var whiteSquare: UIImageView!
    let defaultSquareWidth = CGFloat(150)
    let defaultSquareHeight = CGFloat(150)
    
    var timer : Timer?
    var newSquareTimer : Timer?
    var pleaseFixTimer : Timer?
    var nextTimer : Timer?
    
    // Tracked Values
    var totalError = 0.0
    var tappedSquares = 0
    var numOfSquares = 0
    var bestString = ""
    var paused = false
    
    // TextFile Title Information
    let date = Date()
    let formatter = DateFormatter()
    var currentDate = ""
    var currentTrial = 1
    var trialStatus = ""
    
    // TextFile Data
    var trial = ""
    var imageX = 0.0
    var imageY = 0.0
    var height = 0
    var width = 0
    var imageSize = ""
    var tappedX = 0.0
    var tappedY = 0.0
    var currentStatus = ""
    
    // ImportTuple
    var inputTuple:[(trial: String, imageX: String, imageY: String, imageSize: String, response: String)] = []
    
    // Audio Variables
    var newSquareSoundPlayer = AVAudioPlayer()
    let synthesizer = AVSpeechSynthesizer()
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        importData()
        synthesizer.stopSpeaking(at: .immediate)
        PlayingView.isHidden = true
        HiddenView.isHidden = true
        ConfirmExitButton.isHidden = true
        
        let utterance = AVSpeechUtterance(string: "Please press either the left side for Free Gazing or the right side for Fixation" )
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
        PlayingView.isHidden = false
        
        paused = false
        
        ConfirmExitButton.isHidden = true
        ConfirmExitButton.isUserInteractionEnabled = false
        ExitButton.isHidden = false
        HiddenView.isHidden = false
        levelThree()
        checkNew()
    }
    
    func levelThree() {
        formatter.dateFormat = "MMddyyyy"
        currentDate = formatter.string(from: date)
        
        whiteSquare = UIImageView(image: UIImage(named: "whitesquare"))
        whiteSquare.frame = CGRect(
            x: PlayingView.bounds.width/2 - defaultSquareWidth/2,
            y: PlayingView.bounds.height/2 - defaultSquareHeight/2,
            width: defaultSquareWidth,
            height: defaultSquareHeight
        )
        
        PlayingView.isUserInteractionEnabled = false
        whiteSquare.isUserInteractionEnabled = false
        whiteSquare.isHidden = true
        view.addSubview(whiteSquare)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        let outside = UITapGestureRecognizer(target: self, action: #selector(outsideTapped))
        
        whiteSquare.addGestureRecognizer(tap)
        PlayingView.addGestureRecognizer(outside)
        
        quickPrepareNew()
        
    }
    
    @IBAction func tapped (_ sender: AnyObject){
        synthesizer.stopSpeaking(at: .immediate)
        stopTimerTest()
        
        currentStatus = "tapped"
        let loc:CGPoint = sender.location(in: sender.view)
        
        tappedX = Double(loc.x)
        tappedY = Double(loc.y)
        exportGeneralData()
        
        tappedSquares += 1
        
        PlayingView.isUserInteractionEnabled = false
        whiteSquare.isUserInteractionEnabled = false
        whiteSquare.isHidden = true
        
        goodjob()
        stopNewSquareTest()
        prepareNew()
    }
    
    @IBAction func outsideTapped(_ sender: AnyObject) {
        synthesizer.stopSpeaking(at: .immediate)
        stopTimerTest()
        
        PlayingView.isUserInteractionEnabled = false
        whiteSquare.isUserInteractionEnabled = false
        whiteSquare.isHidden = true
        
        let loc:CGPoint = sender.location(in: sender.view)
        let xDistance = Double(whiteSquare.center.x - loc.x) / 72.0
        let yDistance = Double(whiteSquare.center.y - loc.y) / 72.0
        
        let isRight = xDistance > 0
        let isAbove = yDistance < 0
        
        totalError += (xDistance * xDistance + yDistance * yDistance).squareRoot()
        tappedX = Double(loc.x)
        tappedY = Double(loc.y)
        currentStatus = "wrong"
        exportGeneralData()
        
        if isRight && isAbove{
            let xDistanceStr = String(abs(Int(xDistance)))
            let yDistanceStr = String(abs(Int(yDistance)))
            let utterance = AVSpeechUtterance(string: "Try again, it was " + xDistanceStr + "inches to the right and" + yDistanceStr + "inches above" )
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.5
            
            synthesizer.speak(utterance)
            
        } else if !isRight && isAbove{
            let xDistanceStr = String(abs(Int(xDistance)))
            let yDistanceStr = String(abs(Int(yDistance)))
            let utterance = AVSpeechUtterance(string: "Try again, it was " + xDistanceStr + "inches to the left and" + yDistanceStr + "inches above" )
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.5
            
            synthesizer.speak(utterance)
            
        } else if isRight && !isAbove{
            let xDistanceStr = String(abs(Int(xDistance)))
            let yDistanceStr = String(abs(Int(yDistance)))
            let utterance = AVSpeechUtterance(string: "Try again, it was" + xDistanceStr + "inches to the right and" + yDistanceStr + "inches below" )
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.5
            
            synthesizer.speak(utterance)
        } else{
            let xDistanceStr = String(abs(Int(xDistance)))
            let yDistanceStr = String(abs(Int(yDistance)))
            let utterance = AVSpeechUtterance(string: "Try again, it was " + xDistanceStr + "inches to the left and" + yDistanceStr + "inches below" )
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.5
            
            synthesizer.speak(utterance)
        }
        stopNewSquareTest()
        prepareNew()
    }
    
    @IBAction func giveScore(_ sender: UIButton) {
        synthesizer.stopSpeaking(at: .immediate)
        stopNextPause()
        if newSquareTimer != nil {
            stopNewSquareTest()
            stopFixTimer()
            scorePrepareNew()
        }
        else {
            stopTimerTest()
            startTimer()
        }
        
        let utterance = AVSpeechUtterance(string: "Your current score is " + String(self.tappedSquares) + "out of " + String(self.numOfSquares) + "squares")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        self.synthesizer.speak(utterance)
    }
    
    @IBAction func beginExit(_ sender: UIButton) {
        whiteSquare.isHidden = true
        synthesizer.stopSpeaking(at: .immediate)
        stopNextPause()
        stopTimerTest()
        stopFixTimer()
        stopNewSquareTest()
        
        paused = true
        
        StartButton.setTitle("Resume", for: .normal)
        StartButton.isHidden = false
        ConfirmExitButton.isHidden = false
        ConfirmExitButton.isUserInteractionEnabled = true
        ExitButton.isHidden = true
        
        let utterance = AVSpeechUtterance(string: "You have pressed the exit button. If you are sure, please press the button again. If you would like to continue, press the resume button in the middle of the screen.")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        self.synthesizer.speak(utterance)
    }
    
    @IBAction func confirmExit(_ sender: UIButton) {
        whiteSquare.isHidden = true
        synthesizer.stopSpeaking(at: .immediate)
        stopTimerTest()
        stopNewSquareTest()
        exportRest()
        
        let averageError = totalError / Double(numOfSquares)
        let stringAverageError = String(format: "%.2f", averageError)
        
        let utterance = AVSpeechUtterance(string: "Your final score was " + String(self.tappedSquares) + "out of " + String(self.numOfSquares) + "squares. You were on average" + stringAverageError + "inches away from the square." + " Thank you for playing.")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        self.synthesizer.speak(utterance)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        if whiteSquare.isHidden{
            synthesizer.stopSpeaking(at: .immediate)
            stopTimerTest()
            stopNewSquareTest()
            stopFixTimer()
            nextPause()
        }
    }
    
    func nextPause() {
        guard nextTimer == nil else { return }
        nextTimer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(1),
            target      : self,
            selector    : #selector(newSquare),
            userInfo    : nil,
            repeats     : false)
    }
    
    func stopNextPause() {
        nextTimer?.invalidate()
        nextTimer = nil
    }
    
    func quickPrepareNew() {
        guard newSquareTimer == nil else { return }
        newSquareTimer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(3),
            target      : self,
            selector    : #selector(newSquare),
            userInfo    : nil,
            repeats     : false)
    }
    
    func prepareNew() {
        if !paused{
            startFixTimer()
            
            guard newSquareTimer == nil else { return }
            newSquareTimer =  Timer.scheduledTimer(
                timeInterval: TimeInterval(10),
                target      : self,
                selector    : #selector(newSquare),
                userInfo    : nil,
                repeats     : false)
        }
    }
    
    func scorePrepareNew() {
        guard newSquareTimer == nil else { return }
        newSquareTimer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(10),
            target      : self,
            selector    : #selector(newSquare),
            userInfo    : nil,
            repeats     : false)
    }
    
    func startTimer () {
        
        guard timer == nil else { return }
        timer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(20),
            target      : self,
            selector    : #selector(timeUp),
            userInfo    : nil,
            repeats     : true)
    }
    
    func stopTimerTest() {
        timer?.invalidate()
        timer = nil
    }
    
    func stopNewSquareTest() {
        newSquareTimer?.invalidate()
        newSquareTimer = nil
    }
    
    func startFixTimer () {
        guard pleaseFixTimer == nil else { return }
        pleaseFixTimer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(5),
            target      : self,
            selector    : #selector(pleaseFix),
            userInfo    : nil,
            repeats     : false)
    }
    
    func stopFixTimer() {
        pleaseFixTimer?.invalidate()
        pleaseFixTimer = nil
    }
    
    @IBAction func pleaseFix(){
        let randomInt = Int.random(in: 0..<2)
        if self.trialStatus == "F" && randomInt == 1{
            self.synthesizer.stopSpeaking(at: .immediate)
            let utterance = AVSpeechUtterance(string: "Please fix")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.5
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
        }
        stopFixTimer()
    }
    
    @IBAction func timeUp() {
        whiteSquare.isHidden = true
        PlayingView.isUserInteractionEnabled = false
        whiteSquare.isUserInteractionEnabled = false
        
        currentStatus = "missed"
        exportGeneralData()
        
        let utterance = AVSpeechUtterance(string: "Sorry you ran out of time. Please try again.")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        synthesizer.speak(utterance)
        
        stopTimerTest()
        stopNewSquareTest()
        prepareNew()
    }
    
    func randomLocation(){
        numOfSquares += 1
        
        if !inputTuple.isEmpty{
            let maxX = PlayingView.frame.maxX-defaultSquareWidth
            let maxY = PlayingView.frame.maxY-defaultSquareHeight
            let randomX = arc4random_uniform(UInt32(maxX)) + 0
            let randomY = arc4random_uniform(UInt32(maxY)) + 0
            
            UIView.animate(withDuration: 0) {
                self.whiteSquare.frame = CGRect(
                    x: CGFloat(randomX),
                    y: CGFloat(randomY),
                    width: self.defaultSquareWidth,
                    height: self.defaultSquareHeight
                )
            }
            whiteSquare.isHidden = false
            PlayingView.isUserInteractionEnabled = true
            whiteSquare.isUserInteractionEnabled = true
        } else{
            inputTuple.shuffle()
            let randomSquare = inputTuple[0]
            
            //index
            trial = randomSquare.trial
            
            //xValue & yValue
            imageX = toDouble(s: randomSquare.imageX)
            imageY = toDouble(s: randomSquare.imageY)
            
            //size
            width = toInt(s: randomSquare.imageSize)
            height = toInt(s: randomSquare.imageSize)
            imageSize = randomSquare.imageSize
            
            //status
            currentStatus = "Shown"
            
            UIView.animate(withDuration: 0) {
                self.whiteSquare.frame = CGRect(
                    x: CGFloat(self.imageX),
                    y: CGFloat(self.imageY),
                    width: CGFloat(self.width),
                    height: CGFloat(self.height)
                )
            }
            inputTuple.remove(at: 0)
            whiteSquare.isHidden = false
            PlayingView.isUserInteractionEnabled = true
            whiteSquare.isUserInteractionEnabled = true
        }
    }
    
    func toInt(s: String?) -> Int {
        var result = 0
        if let str: String = s,
           let i = Int(str) {
            result = i
        }
        return result
    }
    
    func toDouble(s: String?) -> Double {
        var result = 0.0
        if let str: String = s,
           let i = Double(str) {
            result = i
        }
        return result
    }
    
    @IBAction func newSquare() {
        stopTimerTest()
        startTimer()
        newSquareSound()
        randomLocation()
    }
    
    func goodjob() {
        let goodJob = AVSpeechUtterance(string: "Good Job")
        goodJob.voice = AVSpeechSynthesisVoice(language: "en-US")
        goodJob.rate = 0.5
        
        synthesizer.speak(goodJob)
    }
    
    func newSquareSound () {
        do {
            let secondaryPath = Bundle.main.path(forResource: "secondary", ofType: "mp3")
            newSquareSoundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: secondaryPath!))
            newSquareSoundPlayer.play()
        }catch{
            print("error, mp3 file not found")
        }
    }
    
    func cleanTabsAndSpace(in text:String) -> String {
        var newText = text
        newText = newText.filter{ $0 != "\t" }.reduce(""){ str, char in
            if let lastChar = str.last, lastChar == " " && lastChar == char {
                return str
            }
            return str + String(char)
        }
        return newText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func importData() {
        if let filepath = Bundle.main.path(forResource: "SettingFile", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                // Clean undesired chars
                let cleanContent = cleanTabsAndSpace(in: contents)
                
                // breaking the text file up into lines
                let lines = cleanContent.components(separatedBy: "\n")
                
                // breaking the lines up into words
                for line in lines {
                    if line.hasPrefix("trial"){
                        continue
                    }
                    if line == ""{
                        continue
                    }
                    let elements = line.components(separatedBy: " ")
                    inputTuple.append((elements[0], elements[1], elements[2],
                                       elements[3],elements[4]))
                }
            } catch {
                print("Content could not be loaded")
            }
        } else {
            print("Text File not Fount")
        }
    }
    func exportGeneralData() {
        imageX = imageX / 72.0
        imageY = imageY / 72.0
        tappedX = tappedX / 72.0
        tappedY = tappedY / 72.0
        
        let imageXStr = String(format: "%.2f", imageX)
        let imageYStr = String(format: "%.2f", imageY)
        let tappedXStr = String(format: "%.2f", tappedX)
        let tappedYStr = String(format: "%.2f", tappedY)
        
        let text = trial.padding(toLength: 18, withPad: " ", startingAt: 0) + imageXStr.padding(toLength: 18, withPad: " ", startingAt: 0) + imageYStr.padding(toLength: 18, withPad: " ", startingAt: 0) + imageSize.padding(toLength: 18, withPad: " ", startingAt: 0) + currentStatus.padding(toLength: 20, withPad: " ", startingAt: 0) + tappedXStr.padding(toLength: 18, withPad: " ", startingAt: 0) + tappedYStr
        
        do {
            let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
            let url = dir.appendingPathComponent("1-O_" + trialStatus + "_" + currentDate + "_level3_run" + String(currentTrial) + ".txt")
            try text.appendLineToURL(fileURL: url as URL)
        }
        catch {
            print("Could not write to file")
        }
    }
    
    func exportOutsideData() {
        let text = trial.padding(toLength: 18, withPad: " ", startingAt: 0) + String(imageX).padding(toLength: 18, withPad: " ", startingAt: 0) + String(imageY).padding(toLength: 18, withPad: " ", startingAt: 0) + imageSize.padding(toLength: 18, withPad: " ", startingAt: 0) + currentStatus.padding(toLength: 20, withPad: " ", startingAt: 0) + String(tappedX).padding(toLength: 18, withPad: " ", startingAt: 0) + String(tappedY)
        
        do {
            let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
            let url = dir.appendingPathComponent("1-O_" + trialStatus + "_" + currentDate + "_level3_run" + String(currentTrial) + ".txt")
            try text.appendLineToURL(fileURL: url as URL)
        }
        catch {
            print("Could not write to file")
        }
    }
    
    func exportRest(){
        if !inputTuple.isEmpty {
            let randomSquare = inputTuple[0]
            
            //index
            trial = randomSquare.trial
            
            //xValue & yValue
            imageX = toDouble(s: randomSquare.imageX)
            imageY = toDouble(s: randomSquare.imageY)
            
            //size
            width = toInt(s: randomSquare.imageSize)
            height = toInt(s: randomSquare.imageSize)
            imageSize = randomSquare.imageSize
            currentStatus = randomSquare.response
            
            let imageXStr = String(format: "%.2f", imageX)
            let imageYStr = String(format: "%.2f", imageY)
            
            let text = trial.padding(toLength: 18, withPad: " ", startingAt: 0) + imageXStr.padding(toLength: 18, withPad: " ", startingAt: 0) + imageYStr.padding(toLength: 18, withPad: " ", startingAt: 0) + imageSize.padding(toLength: 18, withPad: " ", startingAt: 0) + currentStatus
            
            do {
                let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
                let url = dir.appendingPathComponent("1-O_" + trialStatus + "_" + currentDate + "_level3_run" + String(currentTrial) + ".txt")
                try text.appendLineToURL(fileURL: url as URL)
            }catch {
                print("Could not write to file")
            }
            inputTuple.remove(at: 0)
            exportRest()
        }
    }
    
    func checkNew(){
        let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
        let fileManager = FileManager.default
        let url = dir.appendingPathComponent("1-O_" + trialStatus + "_" + currentDate + "_level3_run" + String(currentTrial) + ".txt")
        
        if fileManager.fileExists(atPath: url.path){
            currentTrial += 1
            checkNew()
        } else{
            let text = "trial".padding(toLength: 16, withPad: " ", startingAt: 0) +  "imageX".padding(toLength: 18, withPad: " ", startingAt: 0) + "imageY".padding(toLength: 18, withPad: " ", startingAt: 0) + "imageSize".padding(toLength: 18, withPad: " ", startingAt: 0) + "response".padding(toLength: 18, withPad: " ", startingAt: 0) + "tappedX".padding(toLength: 18, withPad: " ", startingAt: 0) + "tappedY"
            do {
                let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
                let url = dir.appendingPathComponent("1-O_" + trialStatus + "_" + currentDate + "_level3_run" + String(currentTrial) + ".txt")
                try text.appendLineToURL(fileURL: url as URL)
            }
            catch {
                print("Could not write to file")
            }
        }
    }
}
