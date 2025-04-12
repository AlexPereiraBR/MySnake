//
//  ControlsFactory.swift
//  Snake
//
//  Created by Aleksandr Shchukin on 10/04/25.
//

import Foundation
import SpriteKit

class ControlsFactory {
    
    static func makeButton(at point: CGPoint) -> SKNode {
        
        let button = SKShapeNode()
        button.path = UIBezierPath(ovalIn:
                CGRect(x: 0, y: 0, width: 50, height: 50)).cgPath
        button.position = point
        button.fillColor = .gray
        button.strokeColor =
        UIColor.lightGray.withAlphaComponent(0.7)
        button.lineWidth = 10
        return button
        
        
    }
    
}
