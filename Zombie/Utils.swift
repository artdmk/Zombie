//
//  Utils.swift
//  Zombie
//
//  Created by Artem Demchenko on 15.04.16.
//  Copyright © 2016 artdmk. All rights reserved.
//

import Foundation
import CoreGraphics

let π = CGFloat(M_PI)

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x+right.x, y: left.y+right.y)
}

func += (inout left: CGPoint, right: CGPoint){
    left = left + right
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x-right.x, y: left.y-right.y)
}

func -= (inout left: CGPoint, right: CGPoint) {
    left = left - right
}

func * (left: CGPoint, right: CGPoint)->CGPoint{
    return CGPoint(x: left.x*right.x, y: left.y*right.y)
}

func *= (inout left:CGPoint, right: CGPoint) {
    left = left*right
}

func * (point:CGPoint, scalar:CGFloat)->CGPoint {
    return CGPoint(x: point.x*scalar, y: point.y*scalar)
}

func *= (inout point:CGPoint, scalar:CGFloat){
    point = point * scalar
}

func / ( left:CGPoint, right:CGPoint) -> CGPoint{
    return CGPoint(x: left.x/left.x, y: left.y/right.y)
}

func /= (inout left:CGPoint, right:CGPoint){
    left = left/right
}

func / ( point:CGPoint, scalar:CGFloat)->CGPoint{
    return CGPoint(x: point.x/scalar, y: point.y/scalar)
}

func /= (inout point:CGPoint, scalar:CGFloat){
    point = point/scalar
}

#if !(arch(x86_64) || arch(arm64))
    func atan(y: CGFloat, x: CGFloat) -> CGFloat {
        return CGFloat(atan2f(Float(y),Float(x)))
}

    func sqrt(a:CGFloat) -> CGFloat {
        return CGFloat(sqrt(Float(a)))
    }

#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x+y*y)
    }
    
    func normalized() -> CGPoint {
        return self/length()
    }
    
    var angle: CGFloat {
        return atan2(y,x)
    }
}

extension CGFloat {
    func sign() -> CGFloat {
        return (self >= 0.0) ? 1.0 : -1.0
    }
}

func shortestAngelsBetween(angle1: CGFloat, angle2: CGFloat) -> CGFloat {
    
    let twoπ = π * 2.0
    var angle = (angle2 - angle1) % twoπ
    if angle >= π {
        angle = angle - twoπ
    }
    if angle <= -π {
        angle = angle + twoπ
    }
    
    return angle
}

