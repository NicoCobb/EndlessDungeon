//
//  Gameplay.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Gameplay: CCNode, CCPhysicsCollisionDelegate {
    
    weak var roomNode: CCNode!
    weak var gamePhysicsNode: CCPhysicsNode!
    
    weak var character: Character!
    weak var testObject: TestObject!
    
    func didLoadFromCCB() {
        userInteractionEnabled = true

//        gamePhysicsNode.debugDraw = true
        
        let level = CCBReader.load("Rooms/Room1")
        roomNode.addChild(level)
        
        testObject.position = ccp(100, 100)
        
    }
    
    func moveLeft() {
//        character.position.x -= 100
        testObject.position.x -= 100
    }
    
    func moveRight() {
//        character.position.x += 100
        testObject.position.x += 100

    }
    
    func jump() {
//         character.physicsBody.applyImpulse(ccp(0, 400))
    }
    
    func shield() {
        
    }
}