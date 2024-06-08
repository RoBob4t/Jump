
//
//  GameScene.swift
//  MorePhysics
//
//  Created by Harnoor Sethi on 12/18/23.
//

import SpriteKit
import GameplayKit



var score = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    
    var canAdd = true
    var wait = 0
    var ball = SKShapeNode(circleOfRadius: 14.666666984558105)
    let scoreNode = SKLabelNode(text: "0")
    let JUMP_AMOUNT = 650.0
    var liftBall = false
    var oldPos = 0.0
    var newPos = 0.0
    var ballPositions: [CGPoint] = []
    var nodePositions: [CGPoint] = []
    var incrementAmount = 0.001
    
    
    override func didMove(to view: SKView) {
        
        scene?.backgroundColor = .black
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity.dy = -4
        
        
        let text = SKLabelNode(text: "High Score: ")
        text.fontName = "American Typewriter"
        text.fontSize = 30
        text.position.y = view.bounds.height * 0.48
        addChild(text)
        
        
        
        
        scoreNode.fontSize = 50
        scoreNode.fontColor = .white
        scoreNode.position.y = view.bounds.height * 0.6
        scoreNode.name = "score"
        scoreNode.fontName = "Atari Font Full Version"
        addChild(scoreNode)
        
        var points = [CGPoint(x: -300, y: -350),CGPoint(x: 300, y: -350)]
        
        let ground = SKShapeNode(splinePoints: &points,
                                 count: points.count)
        
        ground.lineWidth = 5
        ground.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -300, y: -350), to: CGPoint(x: 300, y: -350))
        ground.physicsBody?.restitution = 0.0
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.friction = 0
        ground.name = "bound0"
        ground.physicsBody?.collisionBitMask = 0xFFFFFFFF
        ground.physicsBody?.contactTestBitMask = 0xFFFFFFFF
        
        addChild(ground)
        
        ball.strokeColor = .gray
        ball.fillColor = .white
        ball.position = CGPoint(x: 0, y: -300)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 14.666666984558105)
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.restitution = 0.0
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.friction = 0
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.collisionBitMask = 0x2
        ball.physicsBody?.contactTestBitMask = 0x1
        addChild(ball)
        
        
        
        for t in 1...200{
            
            let sceneWidth = view.bounds.width
            var posX = CGFloat.random(in: -sceneWidth+200...sceneWidth-200)
            
            
            let posY = t * 70 - 330
            /*
             var bound = Bound(posX: posX, id: t, bound: SKShapeNode())
             
             bound.makeBound()
             
             addChild(bound.bound)
             */
            
            var points = [CGPoint(x: Int(posX)-17, y: posY),CGPoint(x: Int(posX)+17, y: posY)]
            let bound = SKShapeNode(splinePoints: &points, count: 2)
            
            
            bound.lineWidth = 10
            bound.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: Int(posX) - 18, y: posY), to: CGPoint(x: Int(posX) + 18, y: posY))
            bound.physicsBody?.restitution = 0.0
            bound.physicsBody?.isDynamic = false
            bound.physicsBody?.friction = 0
            bound.name = "bound" + "\(t)"
            //bound.physicsBody?.categoryBitMask = 0
            //bound.physicsBody?.collisionBitMask = 0
            //bound.physicsBody?.contactTestBitMask = 0
            
            
            addChild(bound)
        }
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
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
        
        let boundname = "\(String(describing: contact.bodyA.node!.name))"
        print(boundname.dropFirst(15).dropLast(2))
        score = Int(boundname.dropFirst(15).dropLast(2))!
        if Int(scoreNode.text!)! < score{
            scoreNode.text = "\(score)"
        }
        
        if contact.bodyA.node?.name == "ground" || contact.bodyB.node?.name == "ground" || contact.bodyA.node!.name!.contains("bound") || contact.bodyB.node!.name!.contains("bound"){
            liftBall.toggle()
        }
    }
    
    
    var requiredBallPos: CGFloat = 300
    var cycleNum = 0
    var boundary = -UIScreen.main.bounds.size.height + 100
    
    override func update(_ currentTime: TimeInterval) {
        
        
        if ball.position.y < boundary{
            
            
            
            let explosion = SKEmitterNode(fileNamed: "DeathAnimation")
            explosion?.position = CGPoint(x: ball.position.x, y: ball.position.y + 40)
            let explodeAction = SKAction.run {
                
                self.addChild(explosion!)
                self.ball.removeFromParent()
                
            }
            
            let removeExplodeAction = SKAction.run {
                explosion?.removeFromParent()
            }
            let wait = SKAction.wait(forDuration: 0.5)
            let remove = SKAction.run { [self] in
                boundary = -1000000000
            }
            
            let fadeOut = SKAction.fadeAlpha(to: 0, duration: 0.5)
            let runEndScene = SKAction.run {
                var newScene = GameEndScene(size: self.size)
                newScene.scaleMode = SKSceneScaleMode.aspectFill
                newScene.anchorPoint.x = 0.5
                newScene.anchorPoint.y = 0.5
                self.scene?.view!.presentScene(newScene, transition: .fade(with: .black, duration: 2))
            }
            let explodeSequence = SKAction.sequence([explodeAction, wait, remove, removeExplodeAction])
            ball.removeFromParent()
            ball.removeAllActions()
            self.run(explodeSequence)
            let finalSequence = SKAction.sequence([wait, fadeOut, runEndScene])
            self.run(finalSequence)
            
           
            
            
           
        }
        


        
        var opacityAmount = 0.0
        
        enumerateChildNodes(withName: "*BallClone*"){
            node,_  in
            
            node.removeFromParent()
            
        }

        if ballPositions.count > 10{
            
            
            
            ballPositions.remove(at: 0)
            
            if cycleNum == 1{
                
                ballPositions.append(ball.position)
                
            }else{
                cycleNum += 1
            }
            
        }else{
            
            if cycleNum == 1{
                ballPositions.append(ball.position)
                cycleNum -= 2
            }else{
                cycleNum += 1
            }
            
        }

        
    
        for position in ballPositions {
           
            let ballClone = SKShapeNode(circleOfRadius: 14.666666984558105)
            ballClone.fillColor = .white
            ballClone.strokeColor = .gray
            ballClone.position = position
            ballClone.name = "BallClone" + "\(position)"
            ballClone.alpha = opacityAmount
            opacityAmount += 0.1
            addChild(ballClone)
        }


        if ball.physicsBody?.velocity.dx != 0{
            ball.physicsBody?.applyForce(CGVector(dx: -(ball.physicsBody?.velocity.dx)!, dy: 0))
        }

        self.enumerateChildNodes(withName: "*bound*"){

            node,_  in



            if (self.ball.physicsBody?.velocity.dy)! >= -100{

                node.physicsBody?.categoryBitMask = 0

            }else{
             
                node.physicsBody?.categoryBitMask = 0xFFFFFFFF
            }




        }


        if ball.position.y > requiredBallPos{
            if (scene?.anchorPoint.y)! > (-requiredBallPos/scene!.frame.height){
                incrementAmount = 0.001
                
                scene?.anchorPoint.y -= incrementAmount
                scoreNode.position.y += (scene!.frame.height) * incrementAmount
                boundary += (scene!.frame.height) * incrementAmount
                print(boundary)
            }else{
                requiredBallPos += scene!.frame.height/2
                

            }
        }


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
