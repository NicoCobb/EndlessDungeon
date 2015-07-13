//
//  Character.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Character: CCSprite {
    
    weak var sword: CCSprite!
    
    func didLoadFromCCB(){
        self.physicsBody.collisionGroup = "Character"
        sword.physicsBody.collisionGroup = "Character"
    }
}