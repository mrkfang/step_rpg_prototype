//
//  mapScene.swift
//  step_test_with_SK
//
//  Created by Owner on 3/29/17.
//  Copyright © 2017 Owner. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class mapScene: SKScene, AVAudioPlayerDelegate {
    var mapNode: SKSpriteNode?
    var mapHero: SKSpriteNode?
    var dots1: SKSpriteNode?
    var dots2: SKSpriteNode?
    
    var ui_arrow: SKSpriteNode?
    var map_plate: SKSpriteNode?
    var map_go: SKSpriteNode?
    var map_quest: SKSpriteNode?
    var map_cant: SKSpriteNode?
    
    var bgmEffect = AVAudioPlayer()
    
    var selected_dest = ""
    var arrived = false
    
    var cloud1: SKSpriteNode?
    var cloud2: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "wind.mp3", ofType:nil)!)
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            bgmEffect = sound
            sound.numberOfLoops = -1
            sound.play()
        } catch {
            // couldn't load file :(
        }
        
        mapNode = childNode(withName: "ui_start_bg") as? SKSpriteNode
        mapHero = childNode(withName: "maphero") as? SKSpriteNode
        ui_arrow = childNode(withName: "ui_arrow") as? SKSpriteNode
        map_plate = childNode(withName: "map_plate") as? SKSpriteNode
        map_plate?.isHidden = true
        
        map_cant = childNode(withName: "cant_reach") as? SKSpriteNode
        map_go = childNode(withName: "map_go") as? SKSpriteNode
        map_quest = childNode(withName: "map_quest") as? SKSpriteNode
        map_quest?.isHidden = true
        map_go?.isHidden = true
        map_cant?.isHidden = true
        
        dots1 = childNode(withName: "dots1") as? SKSpriteNode
        dots2 = childNode(withName: "dots2") as? SKSpriteNode
        dots1?.isHidden = true
        dots2?.isHidden = true
        
        cloud1 = childNode(withName: "cloud1") as? SKSpriteNode
        cloud2 = childNode(withName: "cloud2") as? SKSpriteNode

        if selected_dest == "button_castle" && arrived == true {
            arrived = false
            mapHero?.position = (childNode(withName: "button_castle")?.position)!
        }
        else if selected_dest == "button_cave" && arrived == true {
            arrived = false
            mapHero?.position = (childNode(withName: "button_cave")?.position)!
        }
        
        ui_arrow?.position.x = (mapHero?.position.x)!
        ui_arrow?.position.y = (mapHero?.position.y)! + 70
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveCloud()
    }
    
    private func initializeGame() {
    }
    
    
    func moveCloud(){
        cloud1?.run( SKAction.move(to: CGPoint(x: -800, y: (cloud1?.position.y)!), duration: 20) )
        cloud2?.run( SKAction.move(to: CGPoint(x: -700, y: (cloud2?.position.y)!), duration: 25) )
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
        //        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
        //            n.position = pos
        //            n.strokeColor = SKColor.red
        //            self.addChild(n)
        //        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        var nextScene = GameScene(fileNamed: "GameScene")
//        nextScene?.size = self.size
//        nextScene?.scaleMode = SKSceneScaleMode.aspectFill
//        self.scene?.view?.presentScene(nextScene!, transition: SKTransition.crossFade(withDuration: 0.5))
        
        if let location = touches.first?.location(in: self) {
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "button_cave" || touchedNode.name == "button_castle" || touchedNode.name == "button_island" {
                
                selected_dest = touchedNode.name!
                print("selected_dest is: \(selected_dest)")
                
                let wait1 = SKAction.wait(forDuration: 0.1)
                let scale = SKAction.scale(to: 0.6, duration: 0.1)
                let scale2 = SKAction.scale(to: 0.7, duration: 0.1)
                let group = SKAction.group([scale, wait1])
                touchedNode.run(group, completion: {touchedNode.run(scale2)})
            }
            // (touchedNode.name == "button_cave" && mapHero?.position == (childNode(withName: "button_cave")?.position)!) ||
            if (touchedNode.name == "button_cave" && mapHero?.position == (childNode(withName: "button_cave")?.position)!) || (touchedNode.name == "maphero" && mapHero?.position == (childNode(withName: "button_cave")?.position)!) {
                ui_arrow?.position.x = touchedNode.position.x
                ui_arrow?.position.y = touchedNode.position.y + 70
                
//                dots1?.isHidden = true
//                dots2?.isHidden = true
                
                map_go?.isHidden = true
                map_quest?.isHidden = false
                map_plate?.isHidden = false
                map_cant?.isHidden = true
            }
                
            else  if (touchedNode.name == "button_island" && mapHero?.position == (childNode(withName: "button_castle")?.position)!) {
                ui_arrow?.position.x = touchedNode.position.x
                ui_arrow?.position.y = touchedNode.position.y + 70
                
                //                dots1?.isHidden = true
                //                dots2?.isHidden = true
                
                map_go?.isHidden = false
                map_quest?.isHidden = true
                map_plate?.isHidden = false
                map_cant?.isHidden = true
            }
                
            else if touchedNode.name == "button_castle" {
                ui_arrow?.position.x = touchedNode.position.x
                ui_arrow?.position.y = touchedNode.position.y + 70
//                dots2?.isHidden = false
//                dots1?.isHidden = true
                map_go?.isHidden = false
                map_quest?.isHidden = true
                map_plate?.isHidden = false
                map_cant?.isHidden = true
            }
            else if touchedNode.name == "button_island" {
                ui_arrow?.position.x = touchedNode.position.x
                ui_arrow?.position.y = touchedNode.position.y + 70
//                dots1?.isHidden = true
//                dots2?.isHidden = true
                map_cant?.isHidden = false
                map_go?.isHidden = true
                map_quest?.isHidden = true
                map_plate?.isHidden = false
            }
            else if touchedNode.name == "button_cave" {
                ui_arrow?.position.x = touchedNode.position.x
                ui_arrow?.position.y = touchedNode.position.y + 70
                
                map_plate?.isHidden = false
                map_go?.isHidden = false
                map_quest?.isHidden = true
                map_cant?.isHidden = true
            }
            else if touchedNode.name == "maphero" {
                ui_arrow?.position.x = touchedNode.position.x
                ui_arrow?.position.y = touchedNode.position.y + 70
                //                dots1?.isHidden = true
                //                dots2?.isHidden = true
                map_plate?.isHidden = true
                map_go?.isHidden = true
                map_cant?.isHidden = true
            }
            else {
//                dots1?.isHidden = true
//                dots2?.isHidden = true
                map_plate?.isHidden = true
                map_go?.isHidden = true
                map_quest?.isHidden = true
                map_cant?.isHidden = true
            }
            if touchedNode.name == "map_quest" {
                let nextScene = questScene(fileNamed: "questScene")
                nextScene?.selected_dest = selected_dest
                nextScene?.size = self.size
                nextScene?.scaleMode = SKSceneScaleMode.aspectFill
                self.scene?.view?.presentScene(nextScene!, transition: SKTransition.crossFade(withDuration: 1.5))
            }
            if touchedNode.name == "map_go" {
                print("route: des1")
                
                let nextScene = GameScene(fileNamed: "GameScene")
                nextScene?.selected_dest = selected_dest
                nextScene?.size = self.size
                nextScene?.scaleMode = SKSceneScaleMode.aspectFill
                self.scene?.view?.presentScene(nextScene!, transition: SKTransition.crossFade(withDuration: 1.5))
            }
        }
        
        //        if let label = self.label {
        //            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        //        }
        //
        //        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}
