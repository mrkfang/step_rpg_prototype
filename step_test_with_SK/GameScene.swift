//
//  GameScene.swift
//  step_test_with_SK
//
//  Created by Owner on 3/27/17.
//  Copyright © 2017 Owner. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import CoreMotion
import AVFoundation
import Foundation


class GameScene: SKScene, AVAudioPlayerDelegate {
    var lastStep = 0
    var currentStep = 0
    var cameraStep = 0
    let pedometer: CMPedometer = CMPedometer()
    let walkAnimation: SKAction = SKAction(named: "walkingPlayer")!
    
    var selected_dest = "" //destination choosen by mapScene

    let bg1 = SKSpriteNode(imageNamed: "bg1")
    var msg = SKLabelNode()
    
    private var mainCamera: SKCameraNode?
    var stepLabel:SKLabelNode?
    var thePlayer:SKSpriteNode! = SKSpriteNode()
    var ui_walk_frame:SKSpriteNode?
    var ui_walk_bg:SKSpriteNode?
    
//    let chest = SKSpriteNode()
    
    var bgmEffect: AVAudioPlayer!
    
    override func didMove(to view: SKView) {
        
        var url = URL(fileURLWithPath: Bundle.main.path(forResource: "soften.mp3", ofType:nil)!)

        if selected_dest == "button_cave" {
            url = URL(fileURLWithPath: Bundle.main.path(forResource: "fall.mp3", ofType:nil)!)
        }
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            bgmEffect = sound
            sound.numberOfLoops = -1
            sound.play()
        } catch {
            // couldn't load file :(
        }
        
//        self.scaleMode = SKSceneScaleMode.aspectFit
        
        msg = (childNode(withName: "arrived_msg") as? SKLabelNode!)!
        msg.isHidden = true
        stepLabel = childNode(withName: "stepLabel") as? SKLabelNode!
        ui_walk_frame = childNode(withName: "ui_walk_frame") as? SKSpriteNode!
        ui_walk_bg = childNode(withName: "ui_walk_bg") as? SKSpriteNode!
        
        if let somePlayer:SKSpriteNode = self.childNode(withName: "Player") as? SKSpriteNode {
//            somePlayer.xScale = somePlayer.xScale * -1; //flips img
            thePlayer = somePlayer
        }
        initializeGame() //attaches camera
        startPedo() //starts pedometer updates
        checkWalking()
        createGrounds()
        if selected_dest == "button_castle" {
            createTree()
        } else {
            createChest()
        }
        
        var timerTest = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: "reachSteps",userInfo: nil, repeats: true)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    private func startPedo(){
        pedometer.startUpdates(from: NSDate() as Date, withHandler: { data, error in
//            print("Update \(data?.numberOfSteps as! Int)")
            DispatchQueue.main.async() {
                self.currentStep = data?.numberOfSteps as! Int
                print("currentStep = \(self.currentStep)")
            }
        })
    }
    private func initializeGame() {
        mainCamera = childNode(withName: "MainCamera") as? SKCameraNode!
    }
    
    func createGrounds() {
        print(selected_dest)
        for i in 0...3 {
            var ground = SKSpriteNode()
            if selected_dest == "button_cave" {
                ground = SKSpriteNode(imageNamed: "desert1")
            } else if selected_dest == "button_castle" {
                ground = SKSpriteNode(imageNamed: "bg1")
            } else {
                ground = SKSpriteNode(imageNamed: "bg5")
            }
            ground.name = "BG1"
            ground.size = CGSize(width: 1200, height: 600)
            ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: 80.0)
            ground.zPosition = -25
            
            self.addChild(ground)
        }
    }
    func moveGrounds(){
        self.enumerateChildNodes(withName: "BG1", using: ({
            (node, error) in
            
            if node.position.x + 1200 < (self.mainCamera?.position.x)! {
                node.position.x += 1200 * 3
            }
        }))
    }
    func createTree(){
        let tree = SKSpriteNode(imageNamed: "tree_fg")
        tree.name = "tree1"
        tree.size = CGSize(width: 300, height: 580)
        tree.position = CGPoint(x: 700, y: 0.0)
        tree.zPosition = 2
        
        self.addChild(tree)
    }
    func moveTree(){
        self.enumerateChildNodes(withName: "tree1", using: ({
            (node, error) in
            node.position.x -= 10
            if node.position.x + 700 < (self.mainCamera?.position.x)! {
                node.position.x += 700 * 2
            }
        }))
    }
    func createChest(){
        let chest = SKSpriteNode(imageNamed: "chest")
        chest.name = "chest"
        chest.size = CGSize(width: 100, height: 80)
        chest.position = CGPoint(x: 900, y: -120)
        chest.zPosition = 1
        self.addChild(chest)
    }
    func pickupChest(){
        self.enumerateChildNodes(withName: "chest", using: ({
            (node, error) in
            if node.position.x - 90 < (self.mainCamera?.position.x)! && self.chestFound == false{
                let wait1 = SKAction.wait(forDuration: 0.1)
                let move1 = SKAction.move(to: CGPoint(x: (self.mainCamera?.position.x)!, y: 60), duration: 0.3)
                let scale2 = SKAction.scale(to: 0, duration: 0.5)
                let move2 = SKAction.move(to: CGPoint(x: (self.mainCamera?.position.x)! + 20, y: -40), duration: 0.3)
                let group = SKAction.group([move1])
                node.run(group, completion: {node.run(move2)})
                node.run(scale2)
                self.chestFound = true
            }
        }))
    }
    
    var walking = false
    var destinationStep = 40;
    var arrivedStatus = false
    var chestFound = false
    
    func plus10(){ self.thePlayer.position.x += 10 } // walk off screen
    func walkOffscreen(){
        thePlayer.run(walkAnimation)
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: "plus10", userInfo: nil, repeats: true)
    }
    
    func reachSteps(){
        if currentStep > destinationStep && arrivedStatus == false{
            arrivedStatus = true
            print("you arrived!")
            walkOffscreen()
            
            msg.alpha = 0.2
            let scale = SKAction.fadeIn(withDuration: 0.6)
            msg.run(scale)
            msg.isHidden = false
        }
        else if cameraStep < currentStep*6 && arrivedStatus == false{
            if walking == false {
                thePlayer.run(walkAnimation)
                walking = true
            }
            cameraStep = cameraStep + 1
            stepLabel?.text = "Steps: \( round(Double(cameraStep/6)) )"
            manageCamera()
            moveGrounds()
            moveTree()
//            if chestFound == false {
                pickupChest()
//                chestFound = true
//            }
        
        } else if arrivedStatus == false{
            thePlayer.removeAllActions()
            walking = false
        }

    }
    func checkWalking(){
        if walking == true{ thePlayer.run(walkAnimation) }
    }
    
    private func manageCamera() {
        self.mainCamera?.position.x += 10
        self.thePlayer.position = (self.mainCamera?.position)!
//        if arrivedStatus == false {
//            self.mainCamera?.position.x += 10
//            self.thePlayer.position = (self.mainCamera?.position)!
//        }
        
        self.stepLabel?.position.x = ((self.mainCamera?.position.x)! + -260)
        self.stepLabel?.position.y = ((self.mainCamera?.position.y)! + 470)
        
//        self.ui_walk_frame?.position.x = (self.mainCamera?.position.x)!
        self.ui_walk_bg?.position.x = (self.mainCamera?.position.x)!
        self.msg.position.x = ((self.mainCamera?.position.x)! + 0)
        self.msg.position.y = ((self.mainCamera?.position.y)! + 120)
    }
    
    
    
    
    
    
    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
    }
    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
//        currentStep += 20
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentStep = currentStep + 10
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//        
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        
        if arrivedStatus == true {
            bgmEffect.stop()
            
            let nextScene = mapScene(fileNamed: "mapScene")
            nextScene?.size = self.size
            nextScene?.scaleMode = SKSceneScaleMode.aspectFill
            
            nextScene?.selected_dest = selected_dest
            nextScene?.arrived = true
            
            self.scene?.view?.presentScene(nextScene!, transition: SKTransition.crossFade(withDuration: 1.5))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}
