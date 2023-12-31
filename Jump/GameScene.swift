//
//  GameScene.swift
//  MorePhysics
//
//  Created by Harnoor Sethi on 12/18/23.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
 /*
    struct Bound{
        
        
        var posX: CGFloat
        var collitionBitMask: UInt32 = 0xFFFFFFFF
        var id: Int
        var bound: SKShapeNode
        
        mutating func makeBound(){
            
            var points = [CGPoint(x: Int(posX)-17, y: id*100 - 300),CGPoint(x: Int(posX)+17, y: id*100   - 300)]
            bound = SKShapeNode(splinePoints: &points, count: 2)
            bound.lineWidth = 5
            bound.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: Int(posX) - 17, y: id*100 - 300), to: CGPoint(x: Int(posX) + 17, y: id*100 - 300))
            bound.physicsBody?.restitution = 0.0
            bound.physicsBody?.isDynamic = false
            bound.physicsBody?.friction = 0
            bound.name = "bound"
            bound.physicsBody?.contactTestBitMask = bound.physicsBody?.collisionBitMask ?? 0
            bound.physicsBody?.collisionBitMask = collitionBitMask
            
        }
        mutating func changeBitMask(ballPosY: CGFloat){
            
            if Int(ballPosY) < Int(id*50) + 30{
                collitionBitMask = 0
            }else{
                
                collitionBitMask = 0xFFFFFFFF
            }
            
        }
        
        
    }
    */
    
  
    public var canAdd = true
    public var wait = 0
    public var ball = SKSpriteNode(imageNamed: "ballGreen")
    let JUMP_AMOUNT = 1500.0
    public var liftBall = false
    public var oldPos = 0.0
    public var newPos = 0.0
    
    override func didMove(to view: SKView) {
        
        
        physicsWorld.contactDelegate = self
        
        
        var points = [CGPoint(x: -300, y: -350),CGPoint(x: 300, y: -350)]
     
        let ground = SKShapeNode(splinePoints: &points,
                                          count: points.count)
        
        ground.lineWidth = 5
        ground.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -300, y: -350), to: CGPoint(x: 300, y: -350))
        ground.physicsBody?.restitution = 0.0
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.friction = 0
        ground.name = "ground"
        ground.physicsBody?.collisionBitMask = 0xFFFFFFFF
        ground.physicsBody?.contactTestBitMask = 0xFFFFFFFF
        
        addChild(ground)
        
       
        ball.position = CGPoint(x: 0, y: -200)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.restitution = 0.0
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.friction = 0
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.collisionBitMask = 0x2
        ball.physicsBody?.contactTestBitMask = 0x1
        addChild(ball)
        
        
        
        for t in 1...100{
           
            let sceneWidth = view.bounds.width
            let posX = CGFloat.random(in: -sceneWidth+50...sceneWidth-50)
            let posY = t*50 - 300
           /*
            var bound = Bound(posX: posX, id: t, bound: SKShapeNode())
            
            bound.makeBound()
            
            addChild(bound.bound)
            */
            
            var points = [CGPoint(x: Int(posX)-17, y: posY),CGPoint(x: Int(posX)+17, y: posY)]
            let bound = SKShapeNode(splinePoints: &points, count: 2)
            bound.lineWidth = 10
            bound.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: Int(posX) - 17, y: posY), to: CGPoint(x: Int(posX) + 17, y: posY))
            bound.physicsBody?.restitution = 0.0
            bound.physicsBody?.isDynamic = false
            bound.physicsBody?.friction = 0
            bound.name = "bound"
            //bound.physicsBody?.categoryBitMask = 0
            //bound.physicsBody?.collisionBitMask = 0
            //bound.physicsBody?.contactTestBitMask = 0
            
        
            addChild(bound)
        }
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
        
    

        print(ball.position.x)
        oldPos = pos.x
        
       // self.addChild(newNode)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
      
        newPos = pos.x
        let dx = newPos-oldPos
        if ball.position.x + dx < 270 && ball.position.x + dx > -270 {
            ball.position.x += dx
        }
        oldPos = newPos
    }
    
    func touchUp(atPoint pos : CGPoint) {

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
    
    func didBegin(_ contact: SKPhysicsContact) {
     

        if contact.bodyA.node?.name == "ground" || contact.bodyB.node?.name == "ground" || contact.bodyA.node?.name == "bound" || contact.bodyB.node?.name == "bound"{
            liftBall.toggle()
         }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if ball.physicsBody?.velocity.dx != 0{
            ball.physicsBody?.applyForce(CGVector(dx: -(ball.physicsBody?.velocity.dx)!, dy: 0))
        }

        self.enumerateChildNodes(withName: "bound"){
            
            node,_  in
            

            
            if (self.ball.physicsBody?.velocity.dy)! > 0{
                
                node.physicsBody?.categoryBitMask = 0
                
            }else{
                
                node.physicsBody?.categoryBitMask = 0xFFFFFFFF
            }
            
            
        
            
        }
        
     /*   if (ball.position.x < -270){
            ball.position.x += 1
        }
        
        if (ball.position.x > 270){
            ball.position.x -= 1
        }
        */
        if liftBall{
            moveBall()
            liftBall.toggle()
        }
        
    }
    
    func moveBall(){
        
        ball.physicsBody?.applyForce(CGVector(dx: 0, dy: JUMP_AMOUNT))
        
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


