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
        physicsBody?.categoryBitMask = Categories.edge // Assign edge category
        physicsWorld.contactDelegate = self
        view.showsPhysics = true
        
        let counterClockwiseButton = ControlsFactory.makeButton(at: CGPoint(x: view.scene!.frame.minX + 30, y: view.scene!.frame.minY + 30))
        counterClockwiseButton.name = "counterClockwiseButton"
        addChild(counterClockwiseButton)
        
        let clockwiseButton = ControlsFactory.makeButton(at: CGPoint(x: view.scene!.frame.maxX - 30 - 50, y: view.scene!.frame.minY + 30))
        clockwiseButton.name = "clockwiseButton"
        addChild(clockwiseButton)
        
        createApple ()
        // Initialize snake at the center of the scene's frame
        snake = Snake(at: CGPoint(x: self.frame.midX, y: self.frame.midY))
        addChild(snake!)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Corrected call to snake's move method
        if !isPaused { // Only move if game is not paused
            snake?.move(currentTime: currentTime)
        }
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
        guard let scene = view?.scene else { // scene could also just be self.frame if view.scene is not appropriate
            return
        }

        // Define a small margin from the edges
        let margin: CGFloat = 10.0 

        // Ensure the random range is valid (maxX > minX + 2*margin)
        // Use scene.size.width and scene.size.height for spawnable area calculation relative to scene origin
        // Assuming scene origin (0,0) is bottom-left for simplicity in spawnable calculation,
        // but use scene.frame.minX/maxX for actual coordinate generation.
        let spawnableWidth = scene.frame.maxX - scene.frame.minX - (2 * margin)
        let spawnableHeight = scene.frame.maxY - scene.frame.minY - (2 * margin)

        guard spawnableWidth > 0 && spawnableHeight > 0 else {
            print("Warning: Not enough space to spawn an apple with current margins.")
            // Handle this case, perhaps by not spawning or using a smaller margin
            return
        }

        let randX = CGFloat.random(in: (scene.frame.minX + margin)...(scene.frame.maxX - margin))
        let randY = CGFloat.random(in: (scene.frame.minY + margin)...(scene.frame.maxY - margin))
        
        let apple = Apple (at: CGPoint(x: randX, y: randY))
        addChild(apple)
        
    }
    
}
        


extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB

        // Sort bodies by category to simplify checks
        let (firstBody, secondBody) = if bodyA.categoryBitMask < bodyB.categoryBitMask {
            (bodyA, bodyB)
        } else {
            (bodyB, bodyA)
        }

        // Check for SnakeHead hitting Apple
        if firstBody.categoryBitMask == Categories.apple && secondBody.categoryBitMask == Categories.snakeHead {
            if let apple = firstBody.node as? Apple {
                apple.disappearAnimation { [weak self] in // Ensure weak self
                    apple.removeFromParent()
                    self?.snake?.addBodyPart()
                    self?.createApple()
                }
            } else if let apple = secondBody.node as? Apple { // Should not happen with sorting, but good for safety
                 apple.disappearAnimation { [weak self] in
                    apple.removeFromParent()
                    self?.snake?.addBodyPart()
                    self?.createApple()
                }
            }
        } 
        // Check for SnakeHead hitting SnakeBody OR SnakeHead hitting Edge
        // Corrected condition: snakeHead (4) is firstBody, snakeBody (8) or edge (16) is secondBody.
        else if firstBody.categoryBitMask == Categories.snakeHead && 
                (secondBody.categoryBitMask == Categories.snakeBody || secondBody.categoryBitMask == Categories.edge) {
            handleGameOver(contactPoint: contact.contactPoint, scenario: secondBody.categoryBitMask == Categories.snakeBody ? "Snake hit its body." : "Snake hit the edge.")
        }
    }
    
    func handleGameOver(contactPoint: CGPoint, scenario: String) {
        print("Game Over: \(scenario) at \(contactPoint)")
        
        // Simple game over effect: Red flash
        let flashNode = SKShapeNode(rectOf: self.frame.size)
        flashNode.fillColor = SKColor.red
        flashNode.alpha = 0.0
        flashNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        flashNode.zPosition = 100 // Ensure it's on top
        addChild(flashNode)
        
        let fadeIn = SKAction.fadeAlpha(to: 0.5, duration: 0.1)
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 0.1)
        let pulse = SKAction.repeat(SKAction.sequence([fadeIn, fadeOut]), count: 2)
        
        flashNode.run(pulse) {
            flashNode.removeFromParent()
            // Pause the scene after the flash
            self.isPaused = true
            
            // Display Game Over Label (simple version)
            let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
            gameOverLabel.text = "Game Over! Tap to Restart."
            gameOverLabel.fontSize = 40
            gameOverLabel.fontColor = SKColor.black
            gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            gameOverLabel.zPosition = 101
            self.addChild(gameOverLabel)
            
            // Add a tap to restart capability
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.restartGame))
            self.view?.addGestureRecognizer(tapRecognizer)
        }
    }
    
    @objc func restartGame() {
        // Remove existing tap recognizers to prevent multiple triggers
        if let recognizers = view?.gestureRecognizers {
            for recognizer in recognizers {
                view?.removeGestureRecognizer(recognizer)
            }
        }
        
        // Create a new scene and transition to it

        // Programmatic creation to ensure a fresh state
        let newScene = GameScene(size: self.size) 
        newScene.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(newScene, transition: transition)

        if let newScene = GameScene(fileNamed: "GameScene") { // Or GameScene(size: self.size) if not using .sks
            newScene.scaleMode = self.scaleMode
            let transition = SKTransition.fade(withDuration: 0.5)
            view?.presentScene(newScene, transition: transition)
        }
    }
}
