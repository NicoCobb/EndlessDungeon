//
//  GameStateSingleton.swift
//  EndlessDungeon
//
//  Created by nico cobb on 8/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class GameStateSingleton: NSObject {
    
    var purchasedWeapons: [AnyObject] = NSUserDefaults.standardUserDefaults().arrayForKey("purchasedWeapons")! {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(purchasedWeapons, forKey: "purchasedWeapons")
            //objectForKey("purchasedWeapons")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    
    class var sharedInstance : WeaponUpgrades {
        struct Static {
            static let instance : WeaponUpgrades = WeaponUpgrades()
        }
        return Static.instance
    }
    
    


    
    
    
    
}