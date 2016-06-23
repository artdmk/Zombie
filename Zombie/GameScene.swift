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
    
    let playableRect: CGRect
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    let movePointsPerSecond: CGFloat = 5.0
    let rotateRadiansPerSecond: CGFloat = 1.0*π
    var velocity = CGPoint(x: 1, y: 1)
    var lastTouchLocation:CGPoint?
    let animation: SKAction
    var background: SKSpriteNode = SKSpriteNode()
    
    let zombie = SKSpriteNode(imageNamed: "zombie1")
    var moveZombie = true
    let changeDirectionSound = SKAction.playSoundFileNamed("changeDirection.wav", waitForCompletion: false)
    let hitCatSound = SKAction.playSoundFileNamed("hitCat.wav", waitForCompletion: false)
    let hitCatLadySound = SKAction.playSoundFileNamed("hitCatLady.wav", waitForCompletion: false)
    
    override init(size: CGSize) {
        
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0, y: playableMargin,
                              width: size.width,
                              height: playableHeight)
        var textures: [SKTexture] = []
        for i in 1...4 {
            textures.append(SKTexture(imageNamed: "zombie\(i)"))
        }
        textures.append(SKTexture(imageNamed: "zombie3"))
        textures.append(SKTexture(imageNamed: "zombie2"))
        textures.append(SKTexture(imageNamed: "zombie1"))
        animation = SKAction.animateWithTextures(textures, timePerFrame: 0.1)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        //set background
        let backgroundTexture = SKTexture(imageNamed: "background1")
        background = SKSpriteNode(texture: backgroundTexture, size: CGSize(width: size.width, height: size.height))
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        addChild(background)
        //set initial zombie position
        zombie.position = CGPoint(x: size.width/2, y: size.height/2)
        zombie.setScale(0.5)
        addChild(zombie)
        zombie.runAction(SKAction.repeatActionForever(animation))
        spawnEnemy()
        
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(spawnCat),SKAction.waitForDuration(1.0)])))
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
        if lastTouchLocation != nil && (lastTouchLocation! - zombie.position).length()<=velocity.length(){
            velocity = CGPointZero
            lastTouchLocation = nil
            zombie.removeAllActions()
            self.moveZombie = true
        } else if velocity != CGPointZero && self.moveZombie{
            zombie.runAction(SKAction.repeatActionForever(animation))
            self.moveZombie = false
        }
        moveSprite(zombie, velocity: velocity)
        checkBounds()
        
        if velocity != CGPointZero {
            rotateSprite(zombie, direction: velocity, rotateRadiansPerSecond: rotateRadiansPerSecond)
        }
    }
    
    override func didEvaluateActions() {
        checkCollisions()
    }
    
    func rotateSprite(sprite:SKSpriteNode, direction:CGPoint, rotateRadiansPerSecond: CGFloat){
        let shortestAngle = shortestAngelsBetween(zombie.zRotation, angle2: velocity.angle)
        let amtToRotate = min(abs(shortestAngle),rotateRadiansPerSecond * CGFloat(dt))
            sprite.zRotation += shortestAngle.sign() * amtToRotate
    }
    
    func moveSpriteToward(location:CGPoint){
        let offset = location - zombie.position
        let direction = offset.normalized()
        velocity = direction * movePointsPerSecond
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
        
        if zombie.position.x <= bottomleft.x{
            zombie.position.x = bottomleft.x
            velocity.x = -velocity.x
            runAction(changeDirectionSound)
        }
        if zombie.position.x >= topRight.x{
            zombie.position.x = topRight.x
            velocity.x = -velocity.x
            runAction(changeDirectionSound)
        }
        if zombie.position.y <= bottomleft.y{
            zombie.position.y = bottomleft.y
            velocity.y = -velocity.y
            runAction(changeDirectionSound)
        }
        if zombie.position.y >= topRight.y{
            zombie.position.y = topRight.y
            velocity.y = -velocity.y
            runAction(changeDirectionSound)
        }
        
    }
    
    func spawnEnemy(){
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.name = "enemy"
        enemy.position = CGPoint(x: size.width - enemy.size.width/2, y: size.height/2)
        enemy.setScale(0.5)
        addChild(enemy)
        let actionMove = SKAction.moveTo(CGPoint(x: enemy.size.width/2, y:size.height/2), duration: 3.0)
        let wait = SKAction.waitForDuration(2.0)
        let actionMidMove = SKAction.moveTo(CGPoint(x: size.width/2, y:  enemy.size.height/2), duration: 3.0)
        let halfSequence = SKAction.sequence([actionMidMove, wait, actionMove])
        let rotation = SKAction.rotateByAngle(rotateRadiansPerSecond, duration: 1)
        let sequence = SKAction.sequence([halfSequence, rotation, halfSequence])
        let repeatAction = SKAction.repeatActionForever(sequence)
        enemy.runAction(repeatAction)
    }
    
    func spawnCat(){
        
        let cat = SKSpriteNode(imageNamed: "cat")
        cat.name = "cat"
        cat.position = CGPoint(x: CGFloat(arc4random())%CGRectGetMaxX(playableRect),y: CGFloat(arc4random())%CGRectGetMaxY(playableRect))
        cat.setScale(0)
        addChild(cat)
        
        let appear = SKAction.scaleTo(0.5, duration: 0.5)
        cat.zRotation = -π / 16.0
        let leftWiggle = SKAction.rotateByAngle(π/8.0, duration: 0.5)
        let rightWiggle = leftWiggle.reversedAction()
        let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle])
        let disappear = SKAction.scaleTo(0, duration: 0.5)
        let removeFromParent = SKAction.removeFromParent()
        let scaleUp = SKAction.scaleBy(0.6, duration: 0.25)
        let scaleDown = scaleUp.reversedAction()
        let fullScale = SKAction.sequence([scaleUp, scaleDown, scaleUp, scaleDown])
        let group = SKAction.group([fullScale, fullWiggle])
        let groupWait = SKAction.repeatAction(group, count: 10)
        let actions = [appear, groupWait, disappear, removeFromParent]
        cat.runAction(SKAction.sequence(actions))
    }
    
    func zombieHitCat(cat: SKSpriteNode){
        cat.removeFromParent()
        runAction(hitCatSound)
    }
    
    func zombieHitEnemy(enemy: SKNode){
        enemy.removeFromParent()
        runAction(hitCatLadySound)
    }
    
    func checkCollisions(){
        var hitCats: [SKSpriteNode] = []
        enumerateChildNodesWithName("cat") { (node, _) in
            let cat = node as! SKSpriteNode
            if CGRectIntersectsRect(cat.frame, self.zombie.frame){
                hitCats.append(cat)
            }
        }
        for cat in hitCats {
            zombieHitCat(cat)
        }
        
        var hitEnemies: [SKNode] = []
        enumerateChildNodesWithName("enemy") { (node, _) in
            if CGRectIntersectsRect(node.frame, self.zombie.frame){
                hitEnemies.append(node)
            }
        }
        for enemy in hitEnemies {
            zombieHitEnemy(enemy)
        }
    }
}
