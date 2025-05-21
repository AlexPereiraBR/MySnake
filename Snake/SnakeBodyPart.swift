//
//  SnakeBodyPart.swift
//  Snake
//
//  Created by Aleksandr Shchukin on 12/04/25.
//

import Foundation
import SpriteKit

class SnakeBodyPart: SKShapeNode {
    let diameter: CGFloat = 16
    
    
    init(at point: CGPoint) {
        super.init()
        
        path = UIBezierPath(ovalIn: CGRect(x: -diameter/2, y: -diameter/2, width: diameter, height: diameter)).cgPath
        fillColor = .green
        strokeColor = .green
        lineWidth = 5
        position = point
        
        physicsBody = SKPhysicsBody(circleOfRadius: diameter/2, center: .zero)
        physicsBody?.categoryBitMask = Categories.snakeBody
        physicsBody?.contactTestBitMask = Categories.none // Head does the testing against body parts
        physicsBody?.collisionBitMask = Categories.none
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
