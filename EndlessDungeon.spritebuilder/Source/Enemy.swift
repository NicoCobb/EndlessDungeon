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

enum enemyDifficultyLevel {
    case Lowest, Lower, Middle, Higher, Highest
}

class Enemy: CCSprite {
    weak var characterReference: CCSprite!
    weak var backgroundReference: CCSprite!
    weak var currentGroundReference: Ground!
    
    var damage = 1
    var health = 1
    var enemySpeed = 2
    var killScore = 10.0
    
    var enemyCollisionHappening = false
    var enemySubType: enemySubTyping = .Grounded
    var enemyDifficulty: enemyDifficultyLevel = .Lowest {
        didSet {
            if enemyDifficulty == .Lowest {
                damage = 1
                health = 1
                enemySpeed = 2
                color = CCColor(red: 0, green: 10, blue: 0)
            } else if enemyDifficulty == .Lower {
                damage = 1
                health = 3
                enemySpeed = 2
                color = CCColor(red: 0, green: 10, blue: 10)
            } else if enemyDifficulty == .Middle {
                damage = 2
                health = 3
                enemySpeed = 3
                color = CCColor(red: 0, green: 0, blue: 40)
            } else if enemyDifficulty == .Higher {
                damage = 3
                health = 4
                enemySpeed = 3
                color = CCColor(red: 10, green: 10, blue: 0)
            } else {
                damage = 5
                health = 5
                enemySpeed = 4
                color = CCColor(red: 50, green: 0, blue: 0)
            }
        }
    }
    
    
    //COLOR CHANGES ARE TEMPORARY UNTIL FINAL ART
    
    func move() {
        
    }
}