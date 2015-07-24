//
//  Enemy.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

enum enemySubTyping {
    case Grounded, Aerial, Ghosting
}

class Enemy: CCSprite {
    var damage = 1
    var health = 1
    var enemySpeed = 2
    var enemySubType : enemySubTyping = .Grounded
    weak var characterReference: CCSprite!
    weak var backgroundReference: CCSprite!
    
    func move() {
        
    }
}