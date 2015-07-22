//
//  Slime.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Slime: Enemy {
    
    func didLoadFromCCB() {
        enemySpeed = 2
        health = 1
        damage = 1
        enemySubType = .Grounded
    }
    
    func move() {
         position.x -= CGFloat(enemySpeed)
    }
    
    override func update(delta: CCTime) {
        move()
    }
}