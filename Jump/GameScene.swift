//
//  GameScene.swift
//  MorePhysics
//
//  Created by Harnoor Sethi on 12/18/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var spinnyNode : SKShapeNode?
    public var canAdd = true
    public var wait = 0
    public var ball = SKSpriteNode(imageNamed: "ballGreen")
    
    
    override func didMove(to view: SKView) {
        
        
        
        
        
        var points = [CGPoint(x: -300, y: -350),CGPoint(x: 300, y: -350)]
        let linearShapeNode = SKShapeNode(points: &points,
                                          count: points.count)
        let ground = SKShapeNode(splinePoints: &points,
                                          count: points.count)
        
        ground.lineWidth = 5
        ground.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -300, y: -350), to: CGPoint(x: 300, y: -350))
        ground.physicsBody?.restitution = 1.0
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.friction = 0
             
        addChild(ground)
        
        
        
        var pointsLeftSide = [CGPoint(x: -300, y: -350),CGPoint(x: -300, y: 350)]
       
        let leftSide = SKShapeNode()
        
        leftSide.lineWidth = 5
        leftSide.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -300, y: -350), to: CGPoint(x: -300, y: 350))
        leftSide.physicsBody?.restitution = 0.0
        leftSide.physicsBody?.isDynamic = false
        leftSide.physicsBody?.friction = 0
             
        addChild(leftSide)
        
        
        var pointsRightSide = [CGPoint(x: 300, y: 350),CGPoint(x: 300, y: -350)]
      
        let rightSide = SKShapeNode()
        
        rightSide.lineWidth = 5
        rightSide.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 300, y: 350), to: CGPoint(x: 300, y: -350))
        rightSide.physicsBody?.restitution = 0.0
        rightSide.physicsBody?.linearDamping = 0.0
        rightSide.physicsBody?.isDynamic = false
        rightSide.physicsBody?.friction = 0
             
        addChild(rightSide)
     
       
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.friction = 0
        
        addChild(ball)
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
        
        
        ball.physicsBody?.applyForce(CGVector(dx: (((pos.x - ball.position.x) > 0) ? -100 : 100), dy: 0))
        
       
       // self.addChild(newNode)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        let newNode = SKSpriteNode(imageNamed: "ballGreen")
        newNode.position = pos
        newNode.physicsBody = SKPhysicsBody(circleOfRadius: newNode.size.width/2)
        newNode.physicsBody?.usesPreciseCollisionDetection = true
        newNode.physicsBody?.restitution = 1.0
        newNode.physicsBody?.linearDamping = 0.0
        newNode.physicsBody?.friction = 0
        if canAdd{
          // self.addChild(newNode)
            canAdd.toggle()
        }
        else{
            wait += 1
            
            if wait == 4{
                
                canAdd = true
                wait -= 5
                
            }
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {


        for t in touches {
            
            self.touchDown(atPoint: t.location(in: self))
      
            let location = t.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "HelloButton" {
                self.enumerateChildNodes(withName: "ballGreen") {
                    (node, stop) in
                    
                    node.removeFromParent()
                }
            }
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
    
    
    override func update(_ currentTime: TimeInterval) {
        if (ball.position.x < -270){
            ball.position.x = -269
        }
        
        if (ball.position.x > 270){
            ball.position.x = 269
        }
        
    }
}
