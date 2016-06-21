//
//  GameScene.swift
//  Zombie
//
//  Created by Artem Demchenko on 06.04.16.
//  Copyright (c) 2016 artdmk. All rights reserved.
//

import UIKit

import SpriteKit
//
class GameScene: SKScene {
    
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    let movePointsPerSecond: CGFloat = 3.0
    let rotateRadiansPerSecond: CGFloat = 1.0*π
    var velocity = CGPoint(x: 1, y: 1)
    var lastTouchLocation:CGPoint?
    
    let mySprite = SKSpriteNode(imageNamed: "zombie1")
    
    override func didMoveToView(view: SKView) {
        //set background
        let background = SKSpriteNode(imageNamed: "background1")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.size     = CGSize(width: size.width, height: size.height)
        background.zPosition = -1
        addChild(background)
        //set initial zombie position
        mySprite.position = CGPoint(x: 200, y: 200)
        mySprite.setScale(0.5)
        addChild(mySprite)
        spawnEnemy()
//        playSound("Siren.mp3")
    }
    
    func moveSprite(sprite:SKSpriteNode, velocity:CGPoint){
        let amountToMove = CGPoint(x:velocity.x, y:velocity.y)
        sprite.position += amountToMove
    }
    
    override func update(currentTime: NSTimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        if lastTouchLocation != nil && (lastTouchLocation! - mySprite.position).length()<=velocity.length(){
            velocity = CGPointZero
            lastTouchLocation = nil
        }
        moveSprite(mySprite, velocity: velocity)
        checkBounds()
        
        if velocity != CGPointZero {
            rotateSprite(mySprite, direction: velocity, rotateRadiansPerSecond: rotateRadiansPerSecond)
        }
    }
    
    func rotateSprite(sprite:SKSpriteNode, direction:CGPoint, rotateRadiansPerSecond: CGFloat){
        let shortestAngle = shortestAngelsBetween(mySprite.zRotation, angle2: velocity.angle)
        let amtToRotate = min(abs(shortestAngle),rotateRadiansPerSecond * CGFloat(dt))
            sprite.zRotation += shortestAngle.sign() * amtToRotate
    }
    
    func moveSpriteToward(location:CGPoint){
        let offset = location-mySprite.position
        let direction = offset.normalized()
        velocity = direction*movePointsPerSecond
    }
    
    func sceneTouched(touchLocation:CGPoint){
        moveSpriteToward(touchLocation)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        lastTouchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        let touchLocation = touch.locationInNode(self)
        lastTouchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
        
    }
    
    func checkBounds(){
        let bottomleft = CGPointZero
        let topRight = CGPointMake(size.width, size.height)
        
        if mySprite.position.x <= bottomleft.x{
            mySprite.position.x = bottomleft.x
            velocity.x = -velocity.x
//            playSound("changeDirection.wav")
        }
        if mySprite.position.x >= topRight.x{
            mySprite.position.x = topRight.x
            velocity.x = -velocity.x
//            playSound("changeDirection.wav")
        }
        if mySprite.position.y <= bottomleft.y{
            mySprite.position.y = bottomleft.y
            velocity.y = -velocity.y
//            playSound("changeDirection.wav")
        }
        if mySprite.position.y >= topRight.y{
            mySprite.position.y = topRight.y
            velocity.y = -velocity.y
//            playSound("changeDirection.wav")
        }
        
    }
    
    func playSound(sound:String){
        runAction(SKAction.playSoundFileNamed(sound, waitForCompletion: false))
    }
    
    func spawnEnemy(){
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.position = CGPoint(x: size.width + enemy.size.width/2, y: size.height/2)
        enemy.setScale(0.5)
        addChild(enemy)
        let actionMove = SKAction.moveTo(CGPoint(x: -enemy.size.width/2, y:enemy.size.height), duration: 2.0)
        let actionMidMove = SKAction.moveTo(CGPoint(x: size.width/2, y: -size.height/2 + enemy.size.height), duration: 2.0)
        let sequence = SKAction.sequence([actionMidMove, actionMove])
        enemy.runAction(sequence)
    }
    
}
