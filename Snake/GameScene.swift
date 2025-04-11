//
//  GameScene.swift
//  Snake
//
//  Created by Aleksandr Shchukin on 10/04/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
 
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.white
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.allowsRotation = false
        view.showsPhysics = true
        
        let counterClockwizeButton = SKShapeNode()
        counterClockwizeButton.path = UIBezierPath(ovalIn:
                CGRect(x: 0, y: 0, width: 50, height: 50)).cgPath
        counterClockwizeButton.position = CGPoint(x: view.scene!.frame.minX + 30,
                                                  y: view.scene!.frame.minY + 30)
        counterClockwizeButton.fillColor = .gray
        counterClockwizeButton.strokeColor =
        UIColor.lightGray.withAlphaComponent(0.7)
        counterClockwizeButton.lineWidth = 10
        counterClockwizeButton.name = "counterClockwizeButton"
        addChild(counterClockwizeButton)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}
