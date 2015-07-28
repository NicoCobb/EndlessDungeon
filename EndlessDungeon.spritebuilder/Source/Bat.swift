//
//  Bat.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Bat: Enemy {
    //Other available variables from Enemy:
    //backgroundReference is a reference variable to the gameplay's background
    //characterReference is a reference variable to the gameplay's character
    
    
    override func didLoadFromCCB() {
        super.didLoadFromCCB()
        scale = 0.5
        enemySubType = .Aerial
        scheduleOnce("moveUp", delay: 1)
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
        
        var moveUp = CCActionMoveTo(duration: 2, position: ccp(CGFloat(self.position.x), CGFloat(randomHigherYPosition)))
        self.runAction(moveUp)
    }

    
    override func update(delta: CCTime) {
    }
}