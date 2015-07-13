//
//  Gameplay.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Gameplay: CCNode {
    
    weak var roomNode: CCNode!
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var character: Character!
    
    func didLoadFromCCB() {
        userInteractionEnabled = true

//        gamePhysicsNode.debugDraw = true
        
        let level = CCBReader.load("Rooms/Room1")
        roomNode.addChild(level)
        
    }
    
    func moveLeft() {
        character.position.x -= 10
    }
    
    func moveRight() {
        character.position.x += 10
    }
    
    func jump() {
        character.
    }
    
    func shield() {
        
    }
}