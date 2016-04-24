//
//  GameScene.swift
//  Zombie
//
//  Created by Artem Demchenko on 06.04.16.
//  Copyright (c) 2016 artdmk. All rights reserved.
//

import UIKit
import SpriteKit

class Zombie:SKSpriteNode {
    let mySprite = SKSpriteNode(imageNamed: "zombie1")
}
class GameScene: SKScene {
    
    let movePositionsPerSecond:CGFloat = 3.0
    var velocity = CGPoint(x: 1, y: 1)
    
    let mySprite = SKSpriteNode(imageNamed: "zombie1")
  
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.blackColor()
        let background = SKSpriteNode(imageNamed: "background1")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.size = CGSize(width: size.width, height: size.height)
        background.zPosition = -1
        addChild(background)
       
        mySprite.position = CGPoint(x: 200, y: 200)
        mySprite.setScale(0.5)
        addChild(mySprite)
        
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        func moveSprite(sprite:SKSpriteNode, velocity:CGPoint){
            let amountToMove = CGPoint(x:velocity.x, y:velocity.y)
            sprite.position += amountToMove}
        
        moveSprite(mySprite, velocity: velocity)
        checkBounds()
        rotateSprite(mySprite, direction: velocity)
        
    }
    
    func rotateSprite(sprite:SKSpriteNode, direction:CGPoint){
        sprite.zRotation = direction.angle
    }
    
    func moveSpriteToward(location:CGPoint){
        let offset = location-mySprite.position
        let direction = offset.normalized()
        velocity = direction*movePositionsPerSecond
    }
    
    func sceneTouched(touchLocation:CGPoint){
        moveSpriteToward(touchLocation)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
    }
    
    func checkBounds(){
        let bottomleft = CGPointZero
        let topRight = CGPoint(x:size.width, y:size.height)
        
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
    
}
