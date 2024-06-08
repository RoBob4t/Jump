//
//  ContentView.swift
//  GitTest
//
//  Created by Harnoor Sethi on 4/23/24.
//

import SwiftUI
import SpriteKit

public var crownPos = 0

class GameScene: SKScene, SKPhysicsContactDelegate{
    

    
    public var canAdd = true
    public var wait = 0
    var ball = SKShapeNode(circleOfRadius: 14.666666984558105)
    let JUMP_AMOUNT = 1300.0
    public var liftBall = false
    public var oldPos = 0.0
    public var newPos = 0.0

    override func sceneDidLoad() {
        
        
        scene?.backgroundColor = .black

        physicsWorld.contactDelegate = self

        self.anchorPoint = CGPoint(x: 1, y: 1)

   




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

            let posX = CGFloat.random(in: -200...200)
            let posY = t*69 - 300
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
            
            scene?.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        }


    }






    func didBegin(_ contact: SKPhysicsContact) {

        print("\(String(describing: contact.bodyA.node?.name))")
        if contact.bodyA.node?.name == "ground" || contact.bodyB.node?.name == "ground" || contact.bodyA.node!.name!.contains("bound") || contact.bodyB.node!.name!.contains("bound"){
            liftBall.toggle()
         }
    }


    var requiredBallPos: CGFloat = 500
    override func update(_ currentTime: TimeInterval) {






        if ball.physicsBody?.velocity.dx != 0{
            ball.physicsBody?.applyForce(CGVector(dx: -(ball.physicsBody?.velocity.dx)!, dy: 0))
        }

        self.enumerateChildNodes(withName: "*bound*"){

            node,_  in



            if (self.ball.physicsBody?.velocity.dy)! >= 0{


                node.physicsBody?.categoryBitMask = 0

            }else{

                node.physicsBody?.categoryBitMask = 0xFFFFFFFF
            }




        }


        if ball.position.y > requiredBallPos{
            if (scene?.anchorPoint.y)! > (-requiredBallPos/500){
                scene?.anchorPoint.y -= 0.001
            }else{
                requiredBallPos += 500
                print(requiredBallPos)

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

    
}

struct ContentView: View {
    
    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 1000, height: 1200)
        scene.anchorPoint.y = 0.5
        scene.scaleMode = SKSceneScaleMode.aspectFill
        return scene
    }
    
    var body: some View {
        
        
            
            SpriteView(scene: scene)
            .frame(width: 200, height: 300)
                .ignoresSafeArea()


      
        
    }
    

}


#Preview {
    ContentView()
}

/*class GameScene: SKScene {
 override func didMove(to view: SKView) {
     physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
 }

 override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     guard let touch = touches.first else { return }
     let location = touch.location(in: self)
     let box = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
     box.position = location
     box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
     addChild(box)
 }
}

// A sample SwiftUI creating a GameScene and sizing it
// at 300x400 points
struct ContentView: View {
 var scene: SKScene {
     let scene = GameScene()
     scene.size = CGSize(width: 300, height: 400)
     scene.scaleMode = .fill
     return scene
 }

 var body: some View {
     SpriteView(scene: scene)
         .frame(width: 300, height: 400)
         .ignoresSafeArea()
 }
}*/
