//
//  Slime.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Slime: Enemy {

//    ALL ENEMY PROPERTIES:
//    weak var characterReference: CCSprite!
//    weak var backgroundReference: CCSprite!
//    weak var currentGroundReference: Ground!
//    
//    var damage = 1
//    var health = 1
//    var enemySpeed = 2
//    
//    var enemyCollisionHappening = false
//    var enemySubType: enemySubTyping = .Grounded
//    var enemyDifficulty: enemyDifficultyLevel = .Lowest
    
    var lastDirection: CGFloat!
    var changeDirectionBufferSpace: CGFloat = 40
    
    func didLoadFromCCB() {
        enemySubType = .Grounded
        lastDirection = CGFloat(enemySpeed)
        moveDown()
    }
    
    override func move() {
        if characterReference.position.x < position.x {
            if (characterReference.position.y - changeDirectionBufferSpace) <= position.y {
                position.x += -CGFloat(enemySpeed)
                lastDirection = -CGFloat(enemySpeed)
            } else {
                position.x += lastDirection
            }
            
        } else {
            if (characterReference.position.y - changeDirectionBufferSpace) <= position.y {
                position.x += CGFloat(enemySpeed)
                lastDirection = CGFloat(enemySpeed)
            } else {
                position.x += lastDirection
            }
        }
        
    }
    
    func moveDown() {
        var placeOnGround = CCActionMoveTo(duration: 1.0/60.0, position: ccp(position.x, 0))
        runAction(placeOnGround)
        
    }
    
    func checkGroundEdgeAndMove() {
        //make sure they're on a ground piece
        if currentGroundReference != nil {
            //check for left edge and move opposite their current direction
            if currentGroundReference.isEndLeft {
                if position.x <= currentGroundReference.position.x + contentSize.width {
                    position.x -= lastDirection
                }
                
            //check for right edge and move opposite their current direction
            } else if currentGroundReference.isEndRight {
                if position.x >= currentGroundReference.position.x + (CGFloat(currentGroundReference.scaleX) * (currentGroundReference.contentSize.width)) - contentSize.width {
                    position.x -= lastDirection
                }
                
            }
            
            //move whenever on the ground
            move()
        }
        
    }
    
    override func update(delta: CCTime) {
        checkGroundEdgeAndMove()
        
//        var delay = CCActionDelay(duration: 2)
//        var startMove = CCActionCallBlock(block: {self.schedule("move", interval: 1.0/60.0)})
//        runAction(CCActionSequence(array: [delay, startMove]))
    }
}