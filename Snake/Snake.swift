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
          // Ensure new body parts are added at the tail's last known position,
          // or head's position if it's the first new part.
          let lastPartPosition = body.last?.position ?? body[0].position
          let bodyPart = SnakeBodyPart(at: lastPartPosition)
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
