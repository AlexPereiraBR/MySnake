//
//  SnakeHead.swift
//  Snake
//
//  Created by Aleksandr Shchukin on 12/04/25.
//

import Foundation
import SpriteKit


class SnakeHead: SnakeBodyPart {
   
    
    override init(at point: CGPoint) {
        super.init(at: point)
        
        let diameter: CGFloat = 24
        path = UIBezierPath(ovalIn: CGRect(x: -diameter/2, y: -diameter/2, width: diameter, height: diameter)).cgPath
        
        
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
