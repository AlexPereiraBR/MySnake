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
        physicsBody?.contactTestBitMask = Categories.snakeHead
        physicsBody?.collisionBitMask = 0
        physicsBody?.isDynamic = false
        
        popAnimation()
    }
    
    
    func popAnimation() {
        self.setScale(0)
        self.alpha = 0
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.2)
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let group = SKAction.group([scaleUp, fadeIn])
        self.run(group)
    }
    
    func disappearAnimation(completion: @escaping () -> Void) {
        let scaleDown = SKAction.scale(to: 0.0, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let group = SKAction.group([scaleDown, fadeOut])
        let remove = SKAction.run(completion)
        let sequence = SKAction.sequence([group, remove])
        self.run(sequence)
    }
}
