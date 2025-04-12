//
//  Snake.swift
//  Snake
//
//  Created by Aleksandr Shchukin on 12/04/25.
//

import Foundation
import SpriteKit


class Snake: SKShapeNode {
    var moveSpeed: CGFloat = 125
    var angle: CGFloat = 0
    
    var body = [SnakeBodyPart]()
    
    convenience init(at point: CGPoint) {
        self.init()
        
        let head = SnakeHead(at: point)
        body.append(head)
        addChild(head)
        
    }
    
      func addBodyPart() {
          let bodyPart = SnakeBodyPart(at: body[0].position)
          body.append(bodyPart)
          addChild(bodyPart)
    }
    
    func move() {
        guard body.isEmpty == false else { return }
        
        moveHead(body[0])
    }
    
    func moveClockwise() {
        angle += CGFloat(Double.pi / 2)
    }
    
    func moveCounterClockwise() {
        angle -= CGFloat(Double.pi / 2)
    }
    
    private func moveHead(_ head: SKShapeNode) {
        let dx =  moveSpeed * sin(angle)
        let dy = moveSpeed * cos(angle)
        
        let nextPoint = CGPoint(x: head.position.x + dx, y: head.position.y + dy)
        let moveAction = SKAction.move(to: nextPoint, duration: 1)
        head.run(moveAction)
    }
    
    private func moveBodyPart() {
        
        
    }
    
}
