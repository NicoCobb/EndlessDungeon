//
//  GameOver.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class GameOver: CCNode {
    
    weak var retryButton: CCButton!
    weak var menuButton: CCButton!
    
    func didLoadFromCCB() {
        retryButton.cascadeOpacityEnabled = true
        retryButton.runAction(CCActionFadeIn(duration: 0.5))
        
        menuButton.cascadeOpacityEnabled = true
        menuButton.runAction(CCActionFadeIn(duration: 0.5))
    }
}