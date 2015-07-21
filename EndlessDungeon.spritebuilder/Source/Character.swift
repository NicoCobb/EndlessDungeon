//
//  Character.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

enum State {
    case Left, Right
}

class Character: CCSprite {
    
    weak var characterBody: CCSprite!
    weak var characterSword: CCSprite!
    
    var canMoveLeft = true
    var canMoveRight = true
    var moveSpeed = 3
    var damage = 1
    var health = 1
    var characterState: State = .Right {
        didSet {
            if characterState == .Right {
                characterBody.position = ccp(8,8)
                characterSword.position = ccp(10,6)
                characterBody.flipX = false
                characterSword.flipX = false
            }
            else if characterState == .Left {
                characterBody.flipX = true
                characterSword.flipX = true
                characterBody.position = ccp(8,8)
                characterSword.position = ccp(-10,6)
            }
        }
    }
    
    func didLoadFromCCB(){
        physicsBody.collisionGroup = "Character"
        characterSword.physicsBody.collisionGroup = "Character"
        characterBody.physicsBody.collisionGroup = "Character"
        
    }
    
    override func update(delta: CCTime) {
        if characterState == .Right{
            characterBody.position = ccp(8,8)
            characterSword.position = ccp(10,6)
        } else if characterState == .Left {
            characterBody.position = ccp(8,8)
            //if only change x position, will not follow when y cooridnate changed
            //(basically, if i jump while facing left, the sword will stay on the ground)
            characterSword.position = ccp(-10,6)

        }
        
    }
    
    func runLeft() {
        if canMoveLeft {
        position.x -= CGFloat(moveSpeed)
        }
    }
    
    func runRight() {
        if canMoveRight {
        position.x += CGFloat(moveSpeed)
        }
    }
    
}