//
//  GameScene.swift
//  PongLevelOne
//
//  Created by Tony Liu on 8/3/20.
//

import SpriteKit
import GameplayKit
import AVFoundation
import Speech

var mainScore = 0
var attempts = 0

class PongLevelOne: SKScene, SKPhysicsContactDelegate {
    
    var ball = SKSpriteNode()
    var main = SKSpriteNode()
    
    //TextFile Data
    var trial = ""
    var currentDate = ""
    var currentTrial = 1
    var currentStatus = ""
    
    //Audio Variables
    var soundPlayer = AVAudioPlayer()
    let synthesizer = AVSpeechSynthesizer()
    
    override func didMove(to view: SKView) {
        
        ball = self.childNode(withName: "neonBall") as! SKSpriteNode
        main = self.childNode(withName: "main") as! SKSpriteNode
        
        
        //how fast the ball moves
        ball.physicsBody?.applyImpulse(CGVector(dx: 30, dy: 30))
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
        physicsWorld.contactDelegate = self
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "enemy" || contact.bodyB.node?.name == "enemy"{
            hitSound()
        }else if contact.bodyA.node?.name == "main" || contact.bodyB.node?.name == "main"{
            goodjob()
            mainScore += 1
        }
        
    }
        
    func addScore(playerWhoLost : SKSpriteNode) {
        attempts += 1
        let randomDirection = Int.random(in: 0...3)
        let xImpulse = Int.random(in: 1...3)
        let yImpulse = Int.random(in: 2...3)
        
        ball.position = CGPoint(x: 0, y:0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        
        if playerWhoLost == main{
            if randomDirection == 0{
                ball.physicsBody?.applyImpulse(CGVector(dx: xImpulse * 10, dy: yImpulse * 10))
            }else if randomDirection == 1{
                ball.physicsBody?.applyImpulse(CGVector(dx: -xImpulse * 10, dy: yImpulse * 10))
            }else if randomDirection == 2{
                ball.physicsBody?.applyImpulse(CGVector(dx: -xImpulse * 10, dy: -yImpulse * 10))
            }else if randomDirection == 3{
                ball.physicsBody?.applyImpulse(CGVector(dx: xImpulse * 10, dy: -yImpulse * 10))
            }
            
            
        }
    }
    
    func hitSound () {
        do {
            let secondaryPath = Bundle.main.path(forResource: "secondary", ofType: "mp3")
            soundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: secondaryPath!))
            soundPlayer.play()
        }catch{
            print("error, mp3 file not found")
        }
    }
    
    func goodjob() {
        synthesizer.stopSpeaking(at: .immediate)
        let goodJob = AVSpeechUtterance(string: "Good Job")
        goodJob.voice = AVSpeechSynthesisVoice(language: "en-US")
        goodJob.rate = 0.5
        
        synthesizer.speak(goodJob)
        
        currentStatus = "Yes"
        exportGeneralData()
    }
    
    func tryagain() {
        synthesizer.stopSpeaking(at: .immediate)
        let tryAgain = AVSpeechUtterance(string: "Try Again")
        tryAgain.voice = AVSpeechSynthesisVoice(language: "en-US")
        tryAgain.rate = 0.5
        
        synthesizer.speak(tryAgain)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = event?.allTouches?.first {
            let location = touch.location(in: self)
            
            main.run(SKAction.moveTo(x: location.x, duration: 0.2))
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = event?.allTouches?.first {
            let location = touch.location(in: self)
            
            main.run(SKAction.moveTo(x: location.x, duration: 0.2))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = event?.allTouches?.first {
            let location = touch.location(in: self)
            
            main.run(SKAction.moveTo(x: location.x, duration: 0.2))
        }
        
    }
        
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if ball.position.y >= main.position.y + 50{
            tryagain()
            addScore(playerWhoLost: main)
            currentStatus = "No"
            exportGeneralData()
        }
    }
        
    func exportGeneralData() {
        
        let text = String(trial).padding(toLength: 18, withPad: " ", startingAt: 0) + currentStatus.padding(toLength: 18, withPad: " ", startingAt: 0)
        
        do {
            let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
            let url = dir.appendingPathComponent(currentDate + "_Pong_" + String(currentTrial) + ".txt")
            try text.appendLineToURL(fileURL: url as URL)
        }
        catch {
            print("Could not write to file")
        }
    }
    
    
    func checkNew(){
        let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
        let fileManager = FileManager.default
        let url = dir.appendingPathComponent(currentDate + "_Pong_" + String(currentTrial) + ".txt")
        
        if fileManager.fileExists(atPath: url.path){
            currentTrial += 1
            checkNew()
        } else{
            let text = "trial".padding(toLength: 16, withPad: " ", startingAt: 0) + "scored".padding(toLength: 18, withPad: " ", startingAt: 0)
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
