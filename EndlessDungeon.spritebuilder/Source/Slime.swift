//
//  Slime.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Slime: Enemy {

    var lastDirection: CGFloat!
    var changeDirectionBufferSpace : CGFloat = 40
    
    override func didLoadFromCCB() {
        super.didLoadFromCCB()
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
        if lastDirection == -CGFloat(enemySpeed) {
            if currentGroundReference != nil && position.x <= currentGroundReference.position.x + 10 {
                move()
            }
        } else if lastDirection == CGFloat(enemySpeed) {
            if currentGroundReference != nil && position.x >= currentGroundReference.position.x - 10 {
                move()
            }
        }
        
    }
    
    override func update(delta: CCTime) {
        checkGroundEdgeAndMove()
        
//        var delay = CCActionDelay(duration: 2)
//        var startMove = CCActionCallBlock(block: {self.schedule("move", interval: 1.0/60.0)})
//        runAction(CCActionSequence(array: [delay, startMove]))
    }
}