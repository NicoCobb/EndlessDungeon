//
//  Character.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Character: CCSprite {
    
    weak var characterBody: CCSprite!
    weak var characterSword: CCSprite!
    
    var canMoveLeft = true
    var canMoveRight = true
    var moveSpeed = 3
    var damage = 1
    var health = 1
    
    func didLoadFromCCB(){
        physicsBody.collisionGroup = "Character"
        characterSword.physicsBody.collisionGroup = "Character"
        characterBody.physicsBody.collisionGroup = "Character"
    }
    
    override func update(delta: CCTime) {
        characterBody.position = ccp(8,8)
        characterSword.position = ccp(10,6)
    }
    
    func moveLeft() {
        if characterBody.flipX == false {
            characterBody.flipX = true
            characterSword.flipX = true
            flipX = true
//            characterSword.position = ccp(characterSword.position.x - CGFloat(scaleX) * CGFloat(characterSword.contentSize.width), characterSword.position.y)
            characterSword.position.x -= CGFloat(scaleX) * CGFloat(characterSword.contentSize.width)
        }
        position.x -= CGFloat(moveSpeed)
        
    }
    
    func moveRight() {
        if characterBody.flipX == true {
            characterBody.flipX = false
            characterSword.flipX = false
            flipX = false
//            characterSword.position = ccp(characterSword.position.x - CGFloat(scaleX) * CGFloat(characterSword.contentSize.width), characterSword.position.y)
            characterSword.position.x -= CGFloat(scaleX) * CGFloat(characterSword.contentSize.width)
        }
        position.x += CGFloat(moveSpeed)
    }
    
}