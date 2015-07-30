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
        //check in the case that it's moving over 2 grounds
        println(numberOfGroundPieces)
        if numberOfGroundPieces > 1 {
            position.x += lastDirection
            return
        }
        
        if lastDirection == -CGFloat(enemySpeed) {
            if currentGroundReference != nil && position.x >= currentGroundReference.position.x {
                move()
            } else {
                var moveBack = CCActionMoveTo(duration: 1.0, position: ccp(position.x + CGFloat(enemySpeed), position.y))
                runAction(moveBack)
            }
        } else if lastDirection == CGFloat(enemySpeed) {
            if currentGroundReference != nil && (position.x <= currentGroundReference.position.x + CGFloat(currentGroundReference.scaleX) * (currentGroundReference.contentSize.width)) {
                move()
            } else {
                var moveBack = CCActionMoveTo(duration: 1.0, position: ccp(position.x - CGFloat(enemySpeed), position.y))
                runAction(moveBack)
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