
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
    weak var background: CCSprite!
    weak var scoreLabel: CCLabelTTF!
    weak var coinLabel: CCLabelTTF!
    weak var contentNode: CCNode!
    weak var buttonNode: CCNode!
    weak var coinAnimated: CoinAnimation!
//    weak var enemy: Enemy!
    
    var coinCount = 0
    var scoreCount = 0
    var actionFollow: CCActionFollow?
    
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
        
        actionFollow = CCActionFollow(target: character, worldBoundary: background.boundingBox())
        contentNode.runAction(actionFollow)
    }

    
//MARK: Collisions
    
    //character and coin collision
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterBody: CCSprite!, coin: Coin!) -> Bool {
        coinCount++
        coinLabel.string = "\(coinCount)"
        if coin.notCollected{
            println("Collecting coin")
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
            enemy.removeFromParent()
            scoreCount += 10
            scoreLabel.string = "\(scoreCount)"
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
//    func moveLeft() {
//        character.position.x -= 100
//    }
//    
//    func moveRight() {
//        character.position = ccp(character.position.x + 100, character.position.y)
//        println(character.position.x)
//    }
    
    
    func jump() {
        character.physicsBody.applyImpulse(ccp(0, 400))
    }
    
    func shield() {
        
    }
    
//MARK: Misc

    
    override func update(delta: CCTime) {
        
        //move character by checking if right/left buttons are highlighted
        if buttonLeft.highlighted {
            if character.canMoveLeft {
                character.characterState = .Left
                character.moveLeft()
//                println(character.characterSword.position.x)
            }
        } else if buttonRight.highlighted {
            if character.canMoveRight {
                character.characterState = .Right
                character.moveRight()
//                println(character.characterSword.position.x)
            }
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

