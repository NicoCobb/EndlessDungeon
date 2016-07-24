//
//  Bat.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Bat: Enemy {

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
    
    
    func didLoadFromCCB() {
        scale = 0.5
        enemySubType = .Aerial
        scheduleOnce("moveUp", delay: 1.0 / 60.0)
        schedule("dive", interval: 4)
    }
    
    func dive() {
        var diveAttackMovement: ccBezierConfig
        
        if characterReference.position.x >= position.x {
            diveAttackMovement = ccBezierConfig(endPosition: ccp(position.x + 100, position.y), controlPoint_1: ccp(position.x + 25, position.y - 400), controlPoint_2: ccp(position.x + 75, position.y - 25))
        } else {
            diveAttackMovement = ccBezierConfig(endPosition: ccp(position.x - 100, position.y), controlPoint_1: ccp(position.x - 25, position.y - 400), controlPoint_2: ccp(position.x - 75, position.y - 25))
        }
        var executableMotion = CCActionBezierTo(duration: 3, bezier: diveAttackMovement)
        self.runAction(executableMotion)
        
    }
    
    func moveUp() {
        var randomHigherYPosition = arc4random_uniform(UInt32(backgroundReference.boundingBox().height - (backgroundReference.boundingBox().height / 2)) + UInt32(backgroundReference.boundingBox().height / 2))
        
        var moveBatUp = CCActionMoveTo(duration: 2, position: ccp(CGFloat(self.position.x), CGFloat(randomHigherYPosition)))
        self.runAction(moveBatUp)
    }

    
    override func update(delta: CCTime) {
    }
}