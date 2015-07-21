//
//  DoorRoom.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/20/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class DoorRoom: CCNode {
    
    weak var doorPlus1: Door!
    weak var doorPlus3: Door!
    weak var doorPlus5: Door!
    weak var doorExit: Door!
    weak var doorSpecial: Door!
    
    func didLoadFromCCB() {
        doorPlus1.doorLabel.string = "+1"
        doorPlus3.doorLabel.string = "+3"
        doorPlus5.doorLabel.string = "+5"
        doorExit.doorLabel.string = "Exit"
        doorSpecial.doorLabel.string = "BOSS"
        
        doorPlus1.currentDoorState = .PlusOne
        doorPlus3.currentDoorState = .PlusThree
        doorPlus5.currentDoorState = .PlusFive
        doorExit.currentDoorState = .Exit
        doorSpecial.currentDoorState = .Special
        
    }
}