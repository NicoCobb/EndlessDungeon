//
//  AllEnemiesSingleton.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/23/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class allEnemiesSingleton {
    
    var allEnemies: [Enemy]? = nil
    static var instance = allEnemiesSingleton()
    
    // SHARED INSTANCE
    class func sharedInstance() -> allEnemiesSingleton {
        self.instance = (self.instance ?? allEnemiesSingleton())
        return self.instance
    }

}