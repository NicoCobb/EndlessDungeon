//
//  Coin.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Coin: CCSprite {
    
    var notCollected = true
    
    func didLoadFromCCB() {
    }
    
    func collect() {
        notCollected = false
        var coinAnimated = CCBReader.load("CoinAnimation")
        coinAnimated.position = self.position
        parent.addChild(coinAnimated)
        removeFromParent()
//        physicsBody.sensor = true
//        physicsBody.affectedByGravity = false
//        
//        animationManager.runAnimationsForSequenceNamed("collected")
//            
//        var delay = CCActionDelay(duration: 1)
//        var remove = CCActionCallBlock(block: {self.removeFromParent()})
//            
//        runAction(CCActionSequence(array: [delay, remove]))
//        
    }
}