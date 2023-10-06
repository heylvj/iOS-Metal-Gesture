//
//  CGPoint+Extension.swift
//  MetalGesture
//
//  Created by 吕劲 on 2023/10/6.
//

import Foundation

extension CGPoint {
    
    static func / (lhs: CGPoint, rhs: CGSize) -> CGPoint {
        return CGPoint(x: lhs.x / rhs.width, y: lhs.y / rhs.height)
    }
    
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func * (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
    }
    
    static func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return lhs * CGPoint(x: rhs, y: rhs)
    }
    
    static func * (lhs: CGFloat, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs, y: lhs) * rhs
    }
}
