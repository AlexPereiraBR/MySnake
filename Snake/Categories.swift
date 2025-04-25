//
//  Categories.swift
//  Snake
//
//  Created by Aleksandr Shchukin on 12/04/25.
//

import Foundation



//struct Categories: Codable {
    //    static let apple: UInt32 = 0x1 << 0
    //    static let snake: UInt32 = 0x1 << 1
    
    struct Categories {
        static let snakeHead: UInt32 = 0x1 << 0
        static let snakeBody: UInt32 = 0x1 << 1
        static let apple: UInt32 = 0x1 << 2
        static let wall: UInt32 = 0x1 << 3
        
        static let snake: UInt32 = snakeHead | snakeBody
        
        
    }
    

