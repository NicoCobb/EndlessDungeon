//
//  Store.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/29/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Store: CCScene {
    
    weak var weaponsButton: CCButton!
    weak var statsButton: CCButton!
    weak var bonusButton: CCButton!
    weak var exitToMenuButton: CCButton!
    weak var enterDungeonButton: CCButton!
    
    func openWeapons() {
        disableButtons()
        
        var weaponsScreen = CCBReader.load("WeaponUpgrades", owner: self)
        weaponsScreen.position = ccp(contentSizeInPoints.width / 2, contentSizeInPoints.height / 2)
        self.addChild(weaponsScreen)
    }
    
    func openStats() {
        disableButtons()
        
        var statScreen = CCBReader.load("StatUpgrades", owner: self)
        statScreen.position = ccp(contentSizeInPoints.width / 2, contentSizeInPoints.height / 2)
        self.addChild(statScreen)
    }
    
    func openBonuses() {
        disableButtons()
        
        var bonusScreen = CCBReader.load("BonusUpgrades", owner: self)
        bonusScreen.position = ccp(contentSizeInPoints.width / 2, contentSizeInPoints.height / 2)
        self.addChild(bonusScreen)
    }
    
    func exitBonuses() {
        enableButtons()
        
        userInteractionEnabled = true
        removeChildByName("bonusUpgrades")
    }
    
    func exitWeapons() {
        enableButtons()
        
        userInteractionEnabled = true
        removeChildByName("weaponUpgrades")
    }
    
    func exitStats() {
        enableButtons()
        
        userInteractionEnabled = true
        removeChildByName("statUpgrades")
    }
    
    func enterDungeon() {
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
    }
    
    func exitToMenu() {
        let mainScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(mainScene)
    }
    
    func disableButtons() {
        weaponsButton.userInteractionEnabled = false
        statsButton.userInteractionEnabled = false
        bonusButton.userInteractionEnabled = false
        exitToMenuButton.userInteractionEnabled = false
        enterDungeonButton.userInteractionEnabled = false
    }
    
    func enableButtons() {
        weaponsButton.userInteractionEnabled = true
        statsButton.userInteractionEnabled = true
        bonusButton.userInteractionEnabled = true
        exitToMenuButton.userInteractionEnabled = true
        enterDungeonButton.userInteractionEnabled = true
    }
}
