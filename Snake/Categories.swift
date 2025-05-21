//
//  Categories.swift
//  Snake
//
//  Created by Aleksandr Shchukin on 12/04/25.
//

import Foundation

struct Categories {
    static let none        : UInt32 = 0
    static let apple       : UInt32 = 0b1      // 1
    static let snake       : UInt32 = 0b10     // 2 (General snake category, if needed)
    static let snakeHead   : UInt32 = 0b100    // 4
    static let snakeBody   : UInt32 = 0b1000   // 8
    static let edge        : UInt32 = 0b10000  // 16
}
