//
//  Door.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

enum doorState {
    case PlusOne, PlusThree, PlusFive, Exit, Special
}

class Door: CCSprite {
    
    weak var doorLabel: CCLabelTTF!
//        didSet {
//            if doorLabel.string == "+1" {
//                currentDoorState = .PlusOne
//            } else if doorLabel.string == "+3" {
//                currentDoorState = .PlusThree
//            } else if doorLabel.string == "+5" {
//                currentDoorState = .PlusFive
//            } else if doorLabel.string == "EXIT" {
//                currentDoorState = .Exit
//            }
//            else {
//                currentDoorState = .Special
//            }
//        }
    
    
    var currentDoorState: doorState = .PlusOne
    
    func didLoadFromCCB() {
        physicsBody.sensor = true
//        if currentDoorState == .PlusOne {
//            doorLabel.string = "+1"
//        } else if currentDoorState == .PlusThree {
//            doorLabel.string = "+3"
//        } else if currentDoorState == .PlusFive {
//            doorLabel.string = "+5"
//        } else if currentDoorState == .Exit {
//            doorLabel.string = "Exit"
//        } else if currentDoorState == .Special {
//            doorLabel.string = "Boss"
//        }
    }
}