//
//  GameScene.swift
//  Snake
//
//  Created by Aleksandr Shchukin on 10/04/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var snake: Snake?
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.white
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.allowsRotation = false
        physicsWorld.contactDelegate = self
        view.showsPhysics = true
        
        let counterClockwiseButton = ControlsFactory.makeButton(at: CGPoint (x: view.scene!.frame.minX + 30, y: view.scene!.frame.minY + 30))
        counterClockwiseButton.name = "counterClockwiseButton"
        addChild(counterClockwiseButton)
        
        let clockwiseButton = ControlsFactory.makeButton(at: CGPoint (x: view.scene!.frame.maxX - 30 - 50, y: view.scene!.frame.minY + 30))
        clockwiseButton.name = "clockwiseButton"
        addChild(clockwiseButton)
        
        createApple ()
        snake = Snake(at: CGPoint (x: view.frame.midX, y: view.frame.midY))
        addChild(snake!)
    }
    
    override func update(_ currentTime: TimeInterval) {
        snake?.move()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        for touch in touches {
            let touchPoint = touch.location(in: self)
            if let touchedNode = atPoint(touchPoint) as? SKShapeNode,
               touchedNode.name == "counterClockwiseButton" ||
                touchedNode.name == "clockwiseButton"  {
                touchedNode.fillColor = .green
                
                if touchedNode.name == "counterClockwiseButton" {
                    snake?.moveCounterClockwise()
                } else if touchedNode.name == "clockwiseButton" {
                    snake?.moveClockwise()
                }
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touchPoint = touch.location(in: self)
            if let touchedNode = atPoint(touchPoint) as? SKShapeNode,
               touchedNode.name == "counterClockwiseButton" ||
                touchedNode.name == "clockwiseButton"  {
                touchedNode.fillColor = .gray
            }
            
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let touchPoint = touch.location(in: self)
            if let touchedNode = atPoint(touchPoint) as? SKShapeNode,
               touchedNode.name == "counterClockwiseButton" ||
                touchedNode.name == "clockwiseButton"  {
                touchedNode.fillColor = .gray
            }
            
        }
        
    }
    
    func createApple () {
        guard let scene = view?.scene else {
            return
        }
        
        let randX =
        CGFloat(arc4random_uniform(UInt32(scene.frame.maxX - 5) + 1))
        let randY =
        CGFloat(arc4random_uniform(UInt32(scene.frame.maxY - 5) + 1))
        
        let apple = Apple (at: CGPoint(x: randX, y: randY))
        addChild(apple)
        
    }
    
}
        


extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        contactMask ^= Categories.snake
        switch contactMask {
        case Categories.apple:
            let apple = contact.bodyA.node is Apple ?
            contact.bodyA.node : contact.bodyB.node
            apple?.removeFromParent()
            snake?.addBodyPart()
            createApple()
            
            default:
            break
            
        }
        
        
    }
}

