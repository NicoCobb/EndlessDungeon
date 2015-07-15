
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
    weak var buttonShield: CCButton!
    weak var character: Character!
    weak var background: CCNode!
    weak var scoreLabel: CCLabelTTF!
    weak var coinLabel: CCLabelTTF!
    weak var contentNode: CCNode!
    
    var coinCount = 0
    var scoreCount = 0
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    func didLoadFromCCB() {
        
        userInteractionEnabled = true
        gamePhysicsNode.debugDraw = true
        gamePhysicsNode.collisionDelegate = self
        
        let level = CCBReader.load("Rooms/Room1", owner: self)
        roomNode.addChild(level)
        
        character.position = ccp(300, 150)
        
    }

    
//MARK: Collisions
    //collision of hero with obstacles
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterBody: CCSprite!, coin: Coin!) -> Bool {
        coinCount++
        coinLabel.string = "\(coinCount)"
        if coin.notCollected{
            coin.collect()
        }
        
        return false
    }

    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterSword: CCSprite!, coin: Coin!) -> Bool {
        return false
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterSword: CCSprite!, enemy: Enemy!) -> Bool {
        if character.damage > enemy.health {
            enemy.removeFromParent()
            return false
        }
        else {
            enemy.health -= character.damage
            return true
        }
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterBody: CCNode!, enemy: Enemy!) -> Bool {
        character.physicsBody.applyImpulse(ccp(100, 100))
        return true
    }
    
//MARK: buttons
//    func moveLeft() {
//        character.position.x -= 100
//    }
    
//    func moveRight() {
//        character.position = ccp(character.position.x + 100, character.position.y)
//        println(character.position.x)
//    }
    
    
    func jump() {
        character.physicsBody.applyImpulse(ccp(0, 400))
    }
    
    func shield() {
        
    }
    
    override func update(delta: CCTime) {
        if buttonLeft.highlighted {
            if character.canMoveLeft {
                character.moveLeft()
            }
        }
        
        if buttonRight.highlighted {
            if character.canMoveRight {
                character.moveRight()
            }
        }
        
        if character.position.x <= 0 {
            character.canMoveLeft = false
        }
        
        if character.position.x >= screenWidth - 10 {
            character.canMoveRight = false
        }
        
        if character.position.x >= screenWidth * 0.75 {
            contentNode.position.x -= CGFloat(character.moveSpeed)
//            roomNode.position.x -= CGFloat(character.moveSpeed)
            character.position.x -= CGFloat(character.moveSpeed)
        }
        
    }
}