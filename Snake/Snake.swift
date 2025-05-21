//
//  Snake.swift
//  Snake
//
//  Created by Aleksandr Shchukin on 12/04/25.
//

import Foundation
import SpriteKit


class Snake: SKShapeNode {
    var moveSpeed: CGFloat = 125 // pixels per second
    var angle: CGFloat = 0
    var body = [SnakeBodyPart]()
    private var lastUpdateTime: TimeInterval = 0
    
    convenience init(at point: CGPoint) {
        self.init()
        
        let head = SnakeHead(at: point)
        body.append(head)
        addChild(head)
        
    }
    
      func addBodyPart() {
        let partSize: CGFloat = 16.0 // From SnakeBodyPart.diameter
        let newPosition: CGPoint

        if body.count == 1 {
            // Only head exists, place new part behind the head
            let head = body[0]
            // Offset is opposite to the snake's current movement direction
            let offsetX = -partSize * sin(self.angle)
            let offsetY = -partSize * cos(self.angle)
            newPosition = CGPoint(x: head.position.x + offsetX, y: head.position.y + offsetY)
        } else {
            // Snake has multiple parts, place new part behind the current tail
            guard let tail = body.last, body.count >= 2 else {
                // Should not happen if body.count > 1, but as a safeguard
                print("Error: Could not determine tail or near-tail part.")
                return
            }
            let nearTail = body[body.count - 2]

            let dx = tail.position.x - nearTail.position.x
            let dy = tail.position.y - nearTail.position.y
            let length = sqrt(dx*dx + dy*dy)

            if length > 0 {
                let normDx = dx / length
                let normDy = dy / length
                // Place new part extending from the tail in the direction of (nearTail -> tail)
                newPosition = CGPoint(x: tail.position.x + normDx * partSize, y: tail.position.y + normDy * partSize)
            } else {
                // Fallback: Parts are stacked or length is zero.
                // Place new part behind the tail using the snake's global angle.
                let offsetX = -partSize * sin(self.angle)
                let offsetY = -partSize * cos(self.angle)
                newPosition = CGPoint(x: tail.position.x + offsetX, y: tail.position.y + offsetY)
            }
        }
        
        let bodyPart = SnakeBodyPart(at: newPosition)
        body.append(bodyPart)
        addChild(bodyPart)
    }
    
    func move(currentTime: TimeInterval) {
        guard !body.isEmpty else { return }

        var deltaTime: TimeInterval = 0
        if lastUpdateTime > 0 {
            deltaTime = currentTime - lastUpdateTime
        }
        // Prevent large jumps if there's a pause or initial very large deltaTime
        deltaTime = min(deltaTime, 0.1) // Cap deltaTime to avoid excessive movement if game lags/resumes
        lastUpdateTime = currentTime

        // Store current positions before any movement
        let oldPositions = body.map { $0.position }

        moveHead(body[0], deltaTime: deltaTime)
        moveBodyParts(oldPositions: oldPositions)
    }
    
    func moveClockwise() {
        angle += CGFloat(Double.pi / 2)
    }
    
    func moveCounterClockwise() {
        angle -= CGFloat(Double.pi / 2)
    }
    
    private func moveHead(_ head: SnakeBodyPart, deltaTime: TimeInterval) {
        let distance = moveSpeed * CGFloat(deltaTime)
        let dx = distance * sin(angle)
        let dy = distance * cos(angle)
        
        head.position = CGPoint(x: head.position.x + dx, y: head.position.y + dy)
    }
    
    private func moveBodyParts(oldPositions: [CGPoint]) {
        guard body.count > 1 else { return }
        
        for i in 1..<body.count {
            body[i].position = oldPositions[i-1]
        }
    }
    
}
