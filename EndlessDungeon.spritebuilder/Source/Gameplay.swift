
//
//  Gameplay.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

//doing owner stuff
//        winPopup = CCBReader.load("WinPopup", owner: self) as! WinPopup

class Gameplay: CCNode, CCPhysicsCollisionDelegate {
    
    weak var roomNode: CCNode!
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var buttonRight: CCButton!
    weak var buttonLeft: CCButton!
    weak var buttonJump: CCButton!
    weak var character: Character!
    weak var background: CCSprite!
    weak var scoreLabel: CCLabelTTF!
    weak var coinLabel: CCLabelTTF!
    weak var contentNode: CCNode!
    weak var buttonNode: CCNode!
    weak var coinAnimated: CoinAnimation!
    weak var doors: DoorRoom!
    weak var groundPiece: CCSprite!
    
    var coinCount = 0
    var scoreCount = 0
    var levelCount = 1
    var roomNumber = 1
    var actionFollow: CCActionFollow?
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    func didLoadFromCCB() {
        
        userInteractionEnabled = true
        multipleTouchEnabled = true
        buttonRight.userInteractionEnabled = false
        buttonLeft.userInteractionEnabled = false
//MARK: DebugDraw
        gamePhysicsNode.debugDraw = true
        gamePhysicsNode.collisionDelegate = self
        
        let level = CCBReader.load("Rooms/Room\(roomNumber)", owner: self)
        roomNode.addChild(level)
        
        character.position = ccp(300, 150)
        
        actionFollow = CCActionFollow(target: character, worldBoundary: background.boundingBox())
        contentNode.runAction(actionFollow)
        
        generateEnemies()
    }

    
//MARK: Collisions
    
    //character and coin collision
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterBody: CCSprite!, coin: Coin!) -> Bool {
        coinCount++
        coinLabel.string = "\(coinCount)"
        if coin.notCollected{
            coin.collect()
        }
        return true
    }

    //sword and coin collision
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterSword: CCSprite!, coin: Coin!) -> Bool {
        return false
    }
    
    //sword and enemy collision
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterSword: CCSprite!, enemy: Enemy!) -> Bool {
        if character.damage >= enemy.health {
            //add score
            scoreCount += 10
            scoreLabel.string = "\(scoreCount)"
            
            //sometimes spawn coin when enemy dies
            var random = CCRANDOM_0_1()
            if random <= 0.5 {
                var newCoin = CCBReader.load("Coin")
                newCoin.position = enemy.position
                newCoin.scale = 0.3
                gamePhysicsNode.addChild(newCoin)
            }
            
            enemy.removeFromParent()
            return false
        }
            
        else {
            enemy.health -= character.damage
            return true
        }
        
    }
    
    
    //character body and enemy collision
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterBody: CCNode!, enemy: Enemy!) -> Bool {
        character.physicsBody.applyImpulse(ccp(100, 100))
        return true
    }
    
//MARK: buttons
    func turnLeft() {
        character.characterState = .Left
    }

    func turnRight() {
        character.characterState = .Right
    }
    
    
    func jump() {
        character.physicsBody.applyImpulse(ccp(0, 400))
    }
    
    func shield() {
        
    }
    
//MARK: Misc

    func generateEnemies() {
        var randomEnemyCount = arc4random_uniform(UInt32(levelCount)) + 1
        
        for enemyNumber in 0...randomEnemyCount {
            var spawnedEnemy: Enemy
            var groundHeight = groundPiece.contentSize.height
            var groundWidth = groundPiece.contentSize.width
            var backgroundHeight = background.contentSize.height
            var backgroundWidth = background.contentSize.width
            
            spawnedEnemy = CCBReader.load("Enemies/Enemy1") as! Enemy
            let enemyXPosition = arc4random_uniform(UInt32(backgroundWidth - groundWidth)) + UInt32(groundWidth)
            let enemyYPosition = arc4random_uniform(UInt32(backgroundHeight - groundHeight)) + UInt32(groundHeight)
            spawnedEnemy.position = ccp(CGFloat(enemyXPosition), CGFloat(enemyYPosition))
            
            gamePhysicsNode.addChild(spawnedEnemy)
        }
        
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        touchMoved(touch, withEvent: event)
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let touchLocation = touch.locationInNode(buttonNode)
        
        //implementation for left button
    
        if CGRectContainsPoint(buttonLeft.boundingBox(), touchLocation) {
            buttonLeft.highlighted = true
            buttonRight.highlighted = false
            turnLeft()
        }
        
        if CGRectContainsPoint(buttonRight.boundingBox(), touchLocation) {
            buttonRight.highlighted = true
            buttonLeft.highlighted = false
            turnRight()
        }
    }

    
    override func update(delta: CCTime) {
        //constant movement
        if character.characterState == .Right {
            character.runRight()
        } else if character.characterState == .Left {
            character.runLeft()
        }
        
        //check for character is at left boundary
        if character.position.x <= 10 {
            character.canMoveLeft = false
        }
        else if character.position.x >= 10 {
                character.canMoveLeft = true
            }
        
        //check for if character is at right boundary
        if character.position.x >= background.boundingBox().width - 10 {
            character.canMoveRight = false
            
        }
        else if character.position.x <= background.boundingBox().width - 10 {
            character.canMoveRight = true
        }
        
    }
}

