//
//  Apple.swift
//  Snake
//
//  Created by Aleksandr Shchukin on 12/04/25.
//

import Foundation
import SpriteKit


class Apple: SKShapeNode {
    
    let diameter: CGFloat = 10
    
    convenience init(at point: CGPoint) {
        self.init()
        
        path = UIBezierPath(ovalIn: CGRect(x: -diameter/2, y: -diameter/2, width: diameter, height: diameter)).cgPath
        position = point
        fillColor = .red
        strokeColor = .red
        lineWidth = 5
        
        physicsBody = SKPhysicsBody(circleOfRadius: diameter/2, center: .zero)
        physicsBody?.categoryBitMask = Categories.apple
        
    }
}
