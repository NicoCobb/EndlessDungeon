//
//  Character.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

enum charState {
    case Left, Right
}

class Character: CCSprite {
    
    weak var characterBody: CCSprite!
    weak var characterSword: CCSprite!
    weak var characterNode: CCNode!
    
    var canMoveLeft = true
    var canMoveRight = true
    var onGround = false
    var invulnerable = false
    
    var moveSpeed = 3
    var damage = 1
    var maxHealth = 5
    var health = 5
    var maxJumps = 1
    var jumpsLeft = 1
    var swordShotTime = 1.0
    var airAttackTime = 0.5
    
    var characterSwordOriginalRightPosition = ccp(12, 8)
    var characterSwordOriginalLeftPosition = ccp(-12 ,8)
    var characterBodyOriginalPosition = ccp(8, 8)
    var characterState: charState = .Right {
        didSet {
            if characterState == .Right {
                characterBody.position = ccp(8,8)
                characterSword.position = ccp(12,8)
                characterBody.flipX = false
                characterSword.flipX = false
            }
            else if characterState == .Left {
                characterBody.flipX = true
                characterSword.flipX = true
                characterBody.position = ccp(8,8)
                characterSword.position = ccp(-12,8)
            }
        }
    }
    
    func didLoadFromCCB(){
        physicsBody.collisionGroup = "Character"
        characterSword.physicsBody.collisionGroup = "Character"
        characterBody.physicsBody.collisionGroup = "Character"
        
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
    
    func groundAttack() {
        var shootSword: CCActionMoveTo
        var returnSword: CCActionMoveTo
        
        if characterState == .Right {
            shootSword = CCActionMoveTo(duration: swordShotTime / 2, position: ccp(CGFloat(characterSwordOriginalRightPosition.x + 100), CGFloat(characterSwordOriginalRightPosition.y)))
            returnSword = CCActionMoveTo(duration: swordShotTime / 2, position: ccp(CGFloat(characterSwordOriginalRightPosition.x), CGFloat(characterSwordOriginalRightPosition.y)))
        } else {
            shootSword = CCActionMoveTo(duration: swordShotTime / 2, position: ccp(CGFloat(characterSwordOriginalLeftPosition.x + 100), CGFloat(characterSwordOriginalLeftPosition.y)))
            returnSword = CCActionMoveTo(duration: swordShotTime / 2, position: ccp(CGFloat(characterSwordOriginalLeftPosition.x), CGFloat(characterSwordOriginalLeftPosition.y)))
        }
        
        var swordAttackMovement = CCActionSequence(one: shootSword, two: returnSword)
        
        var spinSwordForward = CCActionRotateBy(duration: swordShotTime / 2, angle: 1080)
        var spinSwordBackward = CCActionRotateBy(duration: swordShotTime / 2, angle: -1080)
        var swordAttackSpin = CCActionSequence(one: spinSwordForward, two: spinSwordBackward)
        
        characterSword.runAction(swordAttackMovement)
//        characterSword.runAction(swordAttackSpin)
    }
    
    func airAttack() {
        var airSpin = CCActionRotateBy(duration: airAttackTime, angle: 1080)
        characterNode.runAction(airSpin)
    }
    
    func becomeInvulnerable() {
        invulnerable = true
        characterBody.opacity = 0.5
        characterSword.opacity = 0.5
//        if allEnemiesSingleton.sharedInstance().allEnemies != nil {
//            for enemy in allEnemiesSingleton.instance {
//                enemy.physicsBody.collisionGroup = "Character"
//            }
//        }
    }
    
    func endInvulnerable() {
        invulnerable = false
        characterBody.opacity = 1
        characterSword.opacity = 1
//        if allEnemiesSingleton.sharedInstance().allEnemies != nil {
//            for enemy in allEnemiesSingleton.sharedInstance().allEnemies {
//                enemy.physicsBody.collisionGroup = nil
//            }
//        }
    }
    
    override func update(delta: CCTime) {
        
        if characterState == .Right{
            characterBody.position = characterBodyOriginalPosition
            characterSword.position = characterSwordOriginalRightPosition
        } else if characterState == .Left {
            characterBody.position = characterBodyOriginalPosition
            //if only change x position, will not follow when y cooridnate changed
            //(basically, if i jump while facing left, the sword will stay on the ground)
            characterSword.position = characterSwordOriginalLeftPosition
        }
        
    } 
    
}