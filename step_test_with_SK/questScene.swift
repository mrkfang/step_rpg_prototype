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

class questScene: SKScene, AVAudioPlayerDelegate {
    
    var bgmEffect = AVAudioPlayer()
    
    var selected_dest = ""
    var arrived = false
    
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
        
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    private func initializeGame() {
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
            
            bgmEffect.stop()
            
            let nextScene = mapScene(fileNamed: "mapScene")
            nextScene?.size = self.size
            nextScene?.scaleMode = SKSceneScaleMode.aspectFill
            
            nextScene?.selected_dest = "button_cave"
            nextScene?.arrived = true
            
            self.scene?.view?.presentScene(nextScene!, transition: SKTransition.crossFade(withDuration: 1.5))
            
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
