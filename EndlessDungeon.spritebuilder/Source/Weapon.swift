//
//  Weapon.swift
//  EndlessDungeon
//
//  Created by nico cobb on 8/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

struct Weapon {
    
    var weaponName = " "
    var attack = 0
    var extraHealth = 0
    var extraDefense = 0
    var cost = 100
    var spriteFrame = " "
    
    init(newWeaponName: String, newAttack: Int, newExtraHealth: Int, newExtraDefense: Int, newCost: Int, newSpriteFrame: String) {
            attack = 1
            extraHealth = 0
            extraDefense = 0
            cost = 100
            spriteFrame = "FILL IN LATER"
    }
}