
//
//  GameScene.swift
//  MorePhysics
//
//  Created by Harnoor Sethi on 12/18/23.
//

import SpriteKit
import GameplayKit





class GameEndScene: SKScene, SKPhysicsContactDelegate {
    

    
    
    override func didMove(to view: SKView) {
        
      
        scene?.backgroundColor = .black
        
        let scoreNode = SKLabelNode(text: "Score: \(score)")
        scoreNode.name = "score"
        scoreNode.fontName = "Atari Font Full Version"
        addChild(scoreNode)
        
        
        
    
    
    }
}
