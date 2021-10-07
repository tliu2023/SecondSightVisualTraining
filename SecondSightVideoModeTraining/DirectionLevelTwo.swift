//
//  DirectionLevelTwo.swift
//  SecondSightVideoModeTraining
//
//  Created by Tony Liu on 7/27/20.
//

import UIKit
import AVFoundation
import Speech

class DirectionLevelTwo: UIViewController {
    
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
    let defaultSquareWidth = CGFloat(200)
    let defaultSquareHeight = CGFloat(100)
    
    var timer : Timer?
    var newSquareTimer : Timer?
    var pleaseFixTimer : Timer?
    var nextTimer : Timer?
    
    var leftRightTimer : Timer?
    var rightLeftTimer : Timer?
    var upDownTimer : Timer?
    var downUpTimer : Timer?
    var bottomLeftUpperRightTimer : Timer?
    var bottomRightUpperLeftTimer : Timer?
    var upperLeftBottomRightTimer : Timer?
    var upperRightBottomLeftTimer : Timer?
    
    private var lastSwipeBeginningPoint: CGPoint?
    
    var currentSwipe = 0
    
    // Tracked Values
    var swipeCount = 0
    var numOfSwipes = 0
    var bestString = ""
    var beginPoint = CGPoint()
    var swipeAngle = 0.0
    var paused = false
    var inactive = false
    
    // TextFile Title Information
    let date = Date()
    let formatter = DateFormatter()
    var currentDate = ""
    var currentTrial = 1
    var trialStatus = ""
    
    // TextFile Data
    var trial = 0
    var direction = ""
    var beginX = 0.0
    var endX = 0.0
    var beginY = 0.0
    var endY = 0.0
    var currentStatus = ""
    
    // Audio Variables
    var newSquareSoundPlayer = AVAudioPlayer()
    let synthesizer = AVSpeechSynthesizer()
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.stopSpeaking(at: .immediate)
        PlayingView.isHidden = true
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
        PlayingView.isHidden = false
        paused = false
        
        ConfirmExitButton.isHidden = true
        ConfirmExitButton.isUserInteractionEnabled = false
        ExitButton.isHidden = false
        HiddenView.isHidden = false
        beginDirectionDetection()
        checkNew()
    }
    
    func beginDirectionDetection() {
        formatter.dateFormat = "MMddyyyy"
        currentDate = formatter.string(from: date)
        
        whiteSquare = UIImageView(image: UIImage(named: "whitesquare"))
        whiteSquare.frame = CGRect(
            x: PlayingView.bounds.width/2 - defaultSquareWidth/2,
            y: PlayingView.bounds.height/2 - defaultSquareHeight/2,
            width: defaultSquareWidth,
            height: defaultSquareHeight
        )
        
        PlayingView.isUserInteractionEnabled = true
        whiteSquare.isUserInteractionEnabled = false
        whiteSquare.isHidden = true
        view.addSubview(whiteSquare)
        
        let diagonalSwipe = UIPanGestureRecognizer(target: self, action: #selector(diagonalDetection(sender:)))
        
        PlayingView.addGestureRecognizer(diagonalSwipe)
        
        PlayingView.isUserInteractionEnabled = false
        
        quickPrepareNew()
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = event?.allTouches?.first {
            let loc:CGPoint = touch.location(in: touch.view)
            beginPoint = loc
        }
    }
    
    @objc func rightSwipeDetection(sender: UISwipeGestureRecognizer){
        inactive = true
        stopTimerTest()
        if sender.state == .ended {
            PlayingView.isUserInteractionEnabled = false
            if currentSwipe == 1{
                swipeCount += 1
                currentStatus = "yes"
                goodjob()
                stopNewSquareTest()
                prepareNew()
            }else{
                currentStatus = "no"
                synthesizer.stopSpeaking(at: .immediate)
                let utterance = AVSpeechUtterance(string: "Please try again.")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                utterance.rate = 0.5
                synthesizer.speak(utterance)
                stopNewSquareTest()
                prepareNew()
            }
            
            let endPoint = sender.location(in: sender.view)
            beginX = Double(beginPoint.x)
            beginY = Double(beginPoint.y)
            endX = Double(endPoint.x)
            endY = Double(endPoint.y)
            
            exportGeneralData()
        }
    }
    
    @objc func leftSwipeDetection(sender: UISwipeGestureRecognizer){
        inactive = true
        stopTimerTest()
        if sender.state == .ended {
            PlayingView.isUserInteractionEnabled = false
            
            if currentSwipe == 2{
                swipeCount += 1
                currentStatus = "yes"
                goodjob()
                stopNewSquareTest()
                prepareNew()
            }else{
                currentStatus = "no"
                synthesizer.stopSpeaking(at: .immediate)
                let utterance = AVSpeechUtterance(string: "Please try again.")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                utterance.rate = 0.5
                synthesizer.speak(utterance)
                stopNewSquareTest()
                prepareNew()
            }
            
            let endPoint = sender.location(in: sender.view)
            beginX = Double(beginPoint.x)
            beginY = Double(beginPoint.y)
            endX = Double(endPoint.x)
            endY = Double(endPoint.y)
            
            exportGeneralData()
        }
    }
    
    @objc func upSwipeDetection(sender: UISwipeGestureRecognizer){
        inactive = true
        stopTimerTest()
        if sender.state == .ended {
            PlayingView.isUserInteractionEnabled = false
            
            if currentSwipe == 3{
                swipeCount += 1
                currentStatus = "yes"
                goodjob()
                stopNewSquareTest()
                prepareNew()
            }else{
                currentStatus = "no"
                synthesizer.stopSpeaking(at: .immediate)
                let utterance = AVSpeechUtterance(string: "Please try again.")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                utterance.rate = 0.5
                synthesizer.speak(utterance)
                stopNewSquareTest()
                prepareNew()
            }
            
            let endPoint = sender.location(in: sender.view)
            beginX = Double(beginPoint.x)
            beginY = Double(beginPoint.y)
            endX = Double(endPoint.x)
            endY = Double(endPoint.y)
            
            exportGeneralData()
        }
    }
    
    @objc func downSwipeDetection(sender: UISwipeGestureRecognizer){
        inactive = true
        stopTimerTest()
        if sender.state == .ended {
            PlayingView.isUserInteractionEnabled = false
            
            if currentSwipe == 4{
                swipeCount += 1
                currentStatus = "yes"
                goodjob()
                stopNewSquareTest()
                prepareNew()
            }else{
                currentStatus = "no"
                synthesizer.stopSpeaking(at: .immediate)
                let utterance = AVSpeechUtterance(string: "Please try again.")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                utterance.rate = 0.5
                synthesizer.speak(utterance)
                stopNewSquareTest()
                prepareNew()
            }
            
            let endPoint = sender.location(in: sender.view)
            beginX = Double(beginPoint.x)
            beginY = Double(beginPoint.y)
            endX = Double(endPoint.x)
            endY = Double(endPoint.y)
            
            exportGeneralData()
        }
    }
    
    func tan(degrees: Double) -> Double {
        return __tanpi(degrees/180.0)
    }
    
    @objc func diagonalDetection(sender: UISwipeGestureRecognizer) {
        inactive = true
        stopTimerTest()
        if sender.state == .began {
            lastSwipeBeginningPoint = sender.location(in: sender.view)
        } else if sender.state == .ended {
            PlayingView.isUserInteractionEnabled = false
            
            guard let beginPoint = lastSwipeBeginningPoint else {
                return
            }
            let endPoint = sender.location(in: sender.view)
            
            beginX = Double(beginPoint.x)
            beginY = Double(beginPoint.y)
            endX = Double(endPoint.x)
            endY = Double(endPoint.y)
            
            if(endX > beginX){
                swipeAngle = atan((endY - beginY)/(endX - beginX)) * 180 / Double.pi
                print(swipeAngle)
            }
            
            if(endX < beginX){
                swipeAngle = atan((endY - beginY)/(endX - beginX)) * 180 / Double.pi + 180
                print(swipeAngle)
            }
            
            if currentSwipe == 1 && (-20.0...20.0 ~= swipeAngle){
                swipeCount += 1
                currentStatus = "yes"
                goodjob()
                stopNewSquareTest()
                prepareNew()
            }else if currentSwipe == 2 && (160.0...200.0 ~= swipeAngle){
                swipeCount += 1
                currentStatus = "yes"
                goodjob()
                stopNewSquareTest()
                prepareNew()
            }else if currentSwipe == 3 && (250.0...270.0 ~= swipeAngle || -90.0 ... -70.0 ~= swipeAngle){
                swipeCount += 1
                currentStatus = "yes"
                goodjob()
                stopNewSquareTest()
                prepareNew()
            }else if currentSwipe == 4 && (70.0...110.0 ~= swipeAngle){
                swipeCount += 1
                currentStatus = "yes"
                goodjob()
                stopNewSquareTest()
                prepareNew()
            }else if currentSwipe == 5 && (-65.0 ... -25.0 ~= swipeAngle){
                swipeCount += 1
                currentStatus = "yes"
                goodjob()
                stopNewSquareTest()
                prepareNew()
            }else if currentSwipe == 6 && (205.0...245.0 ~= swipeAngle){
                swipeCount += 1
                currentStatus = "yes"
                goodjob()
                stopNewSquareTest()
                prepareNew()
            }else if currentSwipe == 7 && (115.0...155.0 ~= swipeAngle){
                swipeCount += 1
                currentStatus = "yes"
                goodjob()
                stopNewSquareTest()
                prepareNew()
            }else if currentSwipe == 8 && (25.0...65.0 ~= swipeAngle){
                swipeCount += 1
                currentStatus = "yes"
                goodjob()
                stopNewSquareTest()
                prepareNew()
            }else{
                currentStatus = "no"
                synthesizer.stopSpeaking(at: .immediate)
                let utterance = AVSpeechUtterance(string: "Sorry. Please try again next time.")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                utterance.rate = 0.5
                synthesizer.speak(utterance)
                stopNewSquareTest()
                prepareNew()
            }
        }
    }
    
    @objc func swipeDetection(sender: UISwipeGestureRecognizer){
        if sender.state == .ended {
            
        }
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
        
        let utterance = AVSpeechUtterance(string: "Your current score is " + String(self.swipeCount) + "out of " + String(self.numOfSwipes) + "bars")
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
        
        let utterance = AVSpeechUtterance(string: "Your final score was " + String(self.swipeCount) + "out of " + String(self.numOfSwipes) + "bars. Thank you for playing.")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        self.synthesizer.speak(utterance)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        stopNextPause()
        if whiteSquare.isHidden && inactive{
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
            selector    : #selector(newSlide),
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
            selector    : #selector(newSlide),
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
                selector    : #selector(newSlide),
                userInfo    : nil,
                repeats     : false)
        }
    }
    
    func scorePrepareNew() {
        guard newSquareTimer == nil else { return }
        newSquareTimer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(10),
            target      : self,
            selector    : #selector(newSlide),
            userInfo    : nil,
            repeats     : false)
    }
    
    func startTimer () {
        guard timer == nil else { return }
        timer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(10),
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
    
    func startLeftRight() {
        guard leftRightTimer == nil else { return }
        leftRightTimer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(2),
            target      : self,
            selector    : #selector(leftRightAnimate),
            userInfo    : nil,
            repeats     : false)
    }
    
    @IBAction func leftRightAnimate() {
        let originalTransform = whiteSquare.transform
        let TranslatedTransform = originalTransform.translatedBy(x: UIScreen.main.bounds.size.width*0.5 + 100, y: 0)
        UIView.animate(withDuration: 1.5, animations: {
            self.whiteSquare.transform = TranslatedTransform
        })
        leftRightTimer?.invalidate()
        leftRightTimer = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.whiteSquare.isHidden = true
        }
        
    }
    
    func startRightLeft() {
        guard rightLeftTimer == nil else { return }
        rightLeftTimer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(2),
            target      : self,
            selector    : #selector(rightLeftAnimate),
            userInfo    : nil,
            repeats     : false)
    }
    
    @IBAction func rightLeftAnimate() {
        let originalTransform = self.whiteSquare.transform
        let TranslatedTransform = originalTransform.translatedBy(x: -UIScreen.main.bounds.size.width*0.5 - 100, y: 0)
        UIView.animate(withDuration: 1.5, animations: {
            self.whiteSquare.transform = TranslatedTransform
        })
        rightLeftTimer?.invalidate()
        rightLeftTimer = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.whiteSquare.isHidden = true
        }
        
    }
    
    func startUpDown() {
        guard upDownTimer == nil else { return }
        upDownTimer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(2),
            target      : self,
            selector    : #selector(upDownAnimate),
            userInfo    : nil,
            repeats     : false)
    }
    
    @IBAction func upDownAnimate() {
        let originalTransform = whiteSquare.transform
        let TranslatedTransform = originalTransform.translatedBy(x: 0.0, y: UIScreen.main.bounds.size.height*0.5)
        UIView.animate(withDuration: 1.5, animations: {
            self.whiteSquare.transform = TranslatedTransform
        })
        upDownTimer?.invalidate()
        upDownTimer = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.whiteSquare.isHidden = true
        }
    }
    
    func startDownUp() {
        guard downUpTimer == nil else { return }
        downUpTimer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(2),
            target      : self,
            selector    : #selector(downUpAnimate),
            userInfo    : nil,
            repeats     : false)
    }
    
    @IBAction func downUpAnimate() {
        
        let originalTransform = whiteSquare.transform
        let TranslatedTransform = originalTransform.translatedBy(x: 0.0, y: -UIScreen.main.bounds.size.height*0.5)
        UIView.animate(withDuration: 1.5, animations: {
            self.whiteSquare.transform = TranslatedTransform
        })
        downUpTimer?.invalidate()
        downUpTimer = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.whiteSquare.isHidden = true
        }
    }
    
    func startBottomLeftUpperRight() {
        guard bottomLeftUpperRightTimer == nil else { return }
        bottomLeftUpperRightTimer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(2),
            target      : self,
            selector    : #selector(bottomLeftUpperRightAnimate),
            userInfo    : nil,
            repeats     : false)
    }
    
    @IBAction func bottomLeftUpperRightAnimate() {
        UIView.animate(withDuration: 1.5, animations: {
            self.whiteSquare.frame = CGRect(
                x: CGFloat(UIScreen.main.bounds.size.width*0.5 + 100),
                y: CGFloat(UIScreen.main.bounds.size.height*0.25),
                width: CGFloat(250),
                height: CGFloat(125)
            )
            
        })
        bottomLeftUpperRightTimer?.invalidate()
        bottomLeftUpperRightTimer = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.whiteSquare.isHidden = true
        }
    }
    
    func startBottomRightUpperLeft() {
        guard bottomRightUpperLeftTimer == nil else { return }
        bottomRightUpperLeftTimer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(2),
            target      : self,
            selector    : #selector(bottomRightUpperLeftAnimate),
            userInfo    : nil,
            repeats     : false)
    }
    
    @IBAction func bottomRightUpperLeftAnimate() {
        UIView.animate(withDuration: 1.5, animations: {
            self.whiteSquare.center = CGPoint(x: UIScreen.main.bounds.size.width*0.25, y: UIScreen.main.bounds.size.height*0.25)
        })
        bottomRightUpperLeftTimer?.invalidate()
        bottomRightUpperLeftTimer = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.whiteSquare.isHidden = true
        }
    }
    
    func startUpperRightBottomLeft() {
        guard upperRightBottomLeftTimer == nil else { return }
        upperRightBottomLeftTimer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(2),
            target      : self,
            selector    : #selector(upperRightBottomLeftAnimate),
            userInfo    : nil,
            repeats     : false)
    }
    
    @IBAction func upperRightBottomLeftAnimate() {
        UIView.animate(withDuration: 1.5) {
            self.whiteSquare.frame = CGRect(
                x: CGFloat(UIScreen.main.bounds.size.width*0.25),
                y: CGFloat(UIScreen.main.bounds.size.height*0.5),
                width: CGFloat(250),
                height: CGFloat(125)
            )
        }
        bottomLeftUpperRightTimer?.invalidate()
        bottomLeftUpperRightTimer = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.whiteSquare.isHidden = true
        }
    }
    
    func startUpperLeftBottomRight() {
        guard upperLeftBottomRightTimer == nil else { return }
        upperLeftBottomRightTimer =  Timer.scheduledTimer(
            timeInterval: TimeInterval(2),
            target      : self,
            selector    : #selector(upperLeftBottomRightAnimate),
            userInfo    : nil,
            repeats     : false)
    }
    
    @IBAction func upperLeftBottomRightAnimate() {
        UIView.animate(withDuration: 1.5, animations: {
            self.whiteSquare.center = CGPoint(x: UIScreen.main.bounds.size.width*0.70, y: UIScreen.main.bounds.size.height*0.70)
        })
        bottomLeftUpperRightTimer?.invalidate()
        bottomLeftUpperRightTimer = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.whiteSquare.isHidden = true
        }
    }
    
    @IBAction func timeUp() {
        inactive = true
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
    
    func randomSlide(){
        inactive = false
        numOfSwipes += 1
        trial += 1
        
        let randomInt = Int.random(in: 1..<9)
        currentSwipe = randomInt
        whiteSquare.isHidden = false
        PlayingView.isUserInteractionEnabled = true
        
        
        whiteSquare.transform = CGAffineTransform(rotationAngle: CGFloat(0))
        whiteSquare.transform = CGAffineTransform(rotationAngle: CGFloat(0))
        if randomInt == 1{
            direction = "L -> R"
            UIView.animate(withDuration: 0) {
                self.whiteSquare.frame = CGRect(
                    x: CGFloat(UIScreen.main.bounds.size.width*0.5 - 350),
                    y: CGFloat(UIScreen.main.bounds.size.height*0.5 - 150),
                    width: CGFloat(125),
                    height: CGFloat(250)
                )
            }
            leftRightAnimate()
            stopTimerTest()
            startTimer()
        } else if randomInt == 2{
            direction = "R -> L"
            UIView.animate(withDuration: 0) {
                self.whiteSquare.frame = CGRect(
                    x: CGFloat(UIScreen.main.bounds.size.width*0.5 + 250),
                    y: CGFloat(UIScreen.main.bounds.size.height*0.5 - 150),
                    width: CGFloat(125),
                    height: CGFloat(250)
                )
            }
            rightLeftAnimate()
            stopTimerTest()
            startTimer()
        }else if randomInt == 3{
            direction = "D -> U"
            UIView.animate(withDuration: 0) {
                self.whiteSquare.frame = CGRect(
                    x: CGFloat(UIScreen.main.bounds.size.width*0.5 - 100),
                    y: CGFloat(UIScreen.main.bounds.size.height*0.5 + 100),
                    width: CGFloat(250),
                    height: CGFloat(125)
                )
            }
            downUpAnimate()
            stopTimerTest()
            startTimer()
        }else if randomInt == 4{
            direction = "U -> D"
            UIView.animate(withDuration: 0) {
                self.whiteSquare.frame = CGRect(
                    x: CGFloat(UIScreen.main.bounds.size.width*0.5 - 100),
                    y: CGFloat(UIScreen.main.bounds.size.height*0.5 - 275),
                    width: CGFloat(250),
                    height: CGFloat(125)
                )
            }
            upDownAnimate()
            stopTimerTest()
            startTimer()
        } else if randomInt == 5{
            direction = "BL -> UR"
            UIView.animate(withDuration: 0) {
                self.whiteSquare.frame = CGRect(
                    x: CGFloat(UIScreen.main.bounds.size.width*0.25),
                    y: CGFloat(UIScreen.main.bounds.size.height*0.5),
                    width: CGFloat(250),
                    height: CGFloat(125)
                )
                
                
                self.whiteSquare.transform = CGAffineTransform(rotationAngle: CGFloat(3.14/4))
                
                
            }
            bottomLeftUpperRightAnimate()
            stopTimerTest()
            startTimer()
        } else if randomInt == 6{
            direction = "BR -> UL"
            UIView.animate(withDuration: 0) {
                self.whiteSquare.frame = CGRect(
                    x: CGFloat(UIScreen.main.bounds.size.width*0.5),
                    y: CGFloat(UIScreen.main.bounds.size.height*0.5),
                    width: CGFloat(250),
                    height: CGFloat(125)
                )
                self.whiteSquare.transform = CGAffineTransform(rotationAngle: CGFloat(-3.14/4))
            }
            bottomRightUpperLeftAnimate()
            stopTimerTest()
            startTimer()
        } else if randomInt == 7{
            direction = "UR -> BL"
            UIView.animate(withDuration: 0) {
                self.whiteSquare.frame = CGRect(
                    x: CGFloat(UIScreen.main.bounds.size.width*0.5 + 100),
                    y: CGFloat(UIScreen.main.bounds.size.height*0.25),
                    width: CGFloat(250),
                    height: CGFloat(125)
                )
                self.whiteSquare.transform = CGAffineTransform(rotationAngle: CGFloat(3.14/4))
            }
            upperRightBottomLeftAnimate()
            stopTimerTest()
            startTimer()
        } else if randomInt == 8{
            direction = "UL -> BR"
            UIView.animate(withDuration: 0) {
                self.whiteSquare.frame = CGRect(
                    x: CGFloat(UIScreen.main.bounds.size.width*0.25),
                    y: CGFloat(UIScreen.main.bounds.size.height*0.25),
                    width: CGFloat(250),
                    height: CGFloat(125)
                )
                self.whiteSquare.transform = CGAffineTransform(rotationAngle: CGFloat(7*3.14/4))
            }
            upperLeftBottomRightAnimate()
            stopTimerTest()
            startTimer()
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
    
    @IBAction func newSlide() {
        stopTimerTest()
        stopNextPause()
        startTimer()
        newSlideSound()
        randomSlide()
    }
    
    func goodjob() {
        synthesizer.stopSpeaking(at: .immediate)
        let goodJob = AVSpeechUtterance(string: "Good Job")
        goodJob.voice = AVSpeechSynthesisVoice(language: "en-US")
        goodJob.rate = 0.5
        
        synthesizer.speak(goodJob)
    }
    
    func newSlideSound () {
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
    
    
    func exportGeneralData() {
        beginX = beginX / 72.0
        beginY = beginY / 72.0
        endX = endX / 72.0
        endY = endY / 72.0
        
        let beginXStr = String(format: "%.2f", beginX)
        let beginYStr = String(format: "%.2f", beginY)
        let beginXYStr = "(" + beginXStr + ", " + beginYStr + ")"
        
        let endXStr = String(format: "%.2f", endX)
        let endYStr = String(format: "%.2f", endY)
        let endXYStr = "(" + endXStr + ", " + endYStr + ")"
        
        let text = String(trial).padding(toLength: 18, withPad: " ", startingAt: 0) + direction.padding(toLength: 18, withPad: " ", startingAt: 0) + beginXYStr.padding(toLength: 18, withPad: " ", startingAt: 0) + endXYStr.padding(toLength: 20, withPad: " ", startingAt: 0) + currentStatus.padding(toLength: 18, withPad: " ", startingAt: 0)
        
        do {
            let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
            let url = dir.appendingPathComponent(currentDate + "_Direction_Detection" + String(currentTrial) + ".txt")
            try text.appendLineToURL(fileURL: url as URL)
        }
        catch {
            print("Could not write to file")
        }
    }
    
    
    func checkNew(){
        let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
        let fileManager = FileManager.default
        let url = dir.appendingPathComponent(currentDate + "_Direction_Detection" + String(currentTrial) + ".txt")
        
        if fileManager.fileExists(atPath: url.path){
            currentTrial += 1
            checkNew()
        } else{
            let text = "trial".padding(toLength: 16, withPad: " ", startingAt: 0) +  "direction".padding(toLength: 18, withPad: " ", startingAt: 0) + "begin(x,y)".padding(toLength: 18, withPad: " ", startingAt: 0) + "end(x,y)".padding(toLength: 18, withPad: " ", startingAt: 0) + "scored".padding(toLength: 18, withPad: " ", startingAt: 0)
            do {
                let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
                let url = dir.appendingPathComponent(currentDate + "_Direction_Detection" + String(currentTrial) + ".txt")
                try text.appendLineToURL(fileURL: url as URL)
            }
            catch {
                print("Could not write to file")
            }
        }
    }
}
