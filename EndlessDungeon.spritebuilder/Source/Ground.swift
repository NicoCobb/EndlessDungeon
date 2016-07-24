//
//  Ground.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/31/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Ground: CCSprite {
    
    var isEndRight = false
    var isEndLeft = false
    var jumpCheckNode: CCNode!
    
    func didLoadFromCCB() {
        jumpCheckNode.physicsBody.sensor = true
    }
    
}