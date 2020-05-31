//
//  MathUtils.swift
//  ZombieConga
//
//  Created by Michal Ziobro on 27/05/2020.
//  Copyright © 2020 Michal Ziobro. All rights reserved.
//

import Foundation
import CoreGraphics

// +
func + (left: CGPoint, right: CGPoint) -> CGPoint {
    CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += (left: inout CGPoint, right: CGPoint)  {
    left = left + right
}

func + (left: CGPoint, right: CGVector) -> CGPoint {
    CGPoint(x: left.x + right.dx, y: left.y + right.dy)
}

func += (left: inout CGPoint, right: CGVector) {
    left = left + right
}

// -
func - (left: CGPoint, right: CGPoint) -> CGPoint {
    CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func -= (left: inout CGPoint, right: CGPoint)  {
    left = left - right
}

func - (left: CGPoint, right: CGVector) -> CGPoint {
    CGPoint(x: left.x - right.dx, y: left.y - right.dy)
}

func -= (left: inout CGPoint, right: CGVector) {
    left = left - right
}

// *
func * (left: CGPoint, right: CGPoint) -> CGPoint {
    CGPoint(x: left.x * right.x, y: left.y * right.y)
}

func *= (left: inout CGPoint, right: CGPoint)  {
    left = left * right
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func *= (point: inout CGPoint, scalar: CGFloat)  {
    point = point * scalar
}

func * (left: CGVector, right: CGVector) -> CGVector {
    CGVector(dx: left.dx * right.dx, dy: left.dy * right.dy)
}

func *= (left: inout CGVector, right: CGVector) {
    left = left * right
}

func * (vector: CGVector, scalar: CGFloat) -> CGVector {
    CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
}

func *= (vector: inout CGVector, scalar: CGFloat) {
    vector = vector * scalar
}

//
func / (left: CGPoint, right: CGPoint) -> CGPoint {
    CGPoint(x: left.x / right.x, y: left.y / right.y)
}

func /= (left: inout CGPoint, right: CGPoint)  {
    left = left / right
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    CGPoint(x: point.x / scalar, y: point.y / scalar)
}

func /= (point: inout CGPoint, scalar: CGFloat)  {
    point = point / scalar
}

func / (left: CGVector, right: CGVector) -> CGVector {
    CGVector(dx: left.dx / right.dx, dy: left.dy / right.dy)
}

func /= (left: inout CGVector, right: CGVector) {
    left = left / right
}

func / (vector: CGVector, scalar: CGFloat) -> CGVector {
    CGVector(dx: vector.dx / scalar, dy: vector.dy / scalar)
}

func /= (vector: inout CGVector, scalar: CGFloat) {
    vector = vector / scalar
}


#if !(arch(x86_64) || arch(arm64))

func atan2(y: CGFloat, x: CGFloat) -> CGFloat {
    return CGFloat(atan2(Float(y), Float(x)))
}

func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}

#endif

extension CGPoint {
    
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self/length()
    }
    
    var angle: CGFloat {
        return atan2(y, x)
    }
    
    var vector: CGVector {
        return CGVector(dx: self.x, dy: self.y)
    }
}

extension CGVector {
    
    func length() -> CGFloat {
        return sqrt(dx*dx + dy*dy)
    }
    
    func normalized() -> CGVector {
        return self / length()
    }
    
    var angle: CGFloat {
        return atan2(dy, dx)
    }
    
    init(point: CGPoint) {
        self.init(dx: point.x, dy: point.y)
    }
}


let π = CGFloat.pi

func shortestAngleBetween(angle1: CGFloat, angle2: CGFloat) -> CGFloat {
    
    let twoπ = 2.0 * π
    
    var angle = (angle2 - angle1).truncatingRemainder(dividingBy: twoπ)
    
    if angle >= π {
        angle = angle - twoπ
    }
    if angle <= -π {
        angle = angle + twoπ
    }
    
    return angle
}

extension CGFloat {
    func sign() -> CGFloat {
        return self >= 0.0 ? 1.0 : -1.0
    }
}


extension CGFloat {
    
    static func random() -> CGFloat {
        CGFloat(Float(arc4random())/Float(UInt32.max))
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max-min) + min
    }
}
