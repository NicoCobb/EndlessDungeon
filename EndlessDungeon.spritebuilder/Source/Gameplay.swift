
//
//  Gameplay.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

var totalCoins: Int = NSUserDefaults.standardUserDefaults().integerForKey("myCoins") ?? 0 {
    didSet {
        NSUserDefaults.standardUserDefaults().setInteger(totalCoins, forKey:"myCoins")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}


class Gameplay: CCNode, CCPhysicsCollisionDelegate {
    
    weak var roomNode: CCNode!
    weak var contentNode: CCNode!
    weak var buttonNode: CCNode!
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var exitDungeonLayer: CCNode!
    
    weak var buttonRight: CCButton!
    weak var buttonLeft: CCButton!
    weak var buttonJump: CCButton!
    weak var buttonContinue: CCButton!
    
    weak var character: Character!
    weak var background: CCSprite!
    weak var scoreLabel: CCLabelTTF!
    weak var coinLabel: CCLabelTTF!
    weak var healthLabel: CCLabelTTF!

    weak var coinAnimated: CoinAnimation!
    weak var doors: DoorRoom!
    weak var groundPiece: CCSprite!
    
    //buttons from Exit Dungeon Layer
    weak var noExitDungeonButton: CCButton!
    weak var yesExitDungeonButton: CCButton!
    
    var coinCount = 0
    var scoreCount = 0
    var levelNumber = 1
    var roomNumber = 1
    var totalRooms = 3
    var totalEnemyTypes = 2
    var actionFollow: CCActionFollow?
    var currentDoor: Door?
    var room: CCNode!
    //MARK: dead
    var characterHitFlag = false {
        didSet {
            if character.health <= 0 {
                userInteractionEnabled = false
                self.paused = true
                
                var gameOverScreen = CCBReader.load("GameOver", owner: self) as! GameOver
                self.addChild(gameOverScreen)
            }
        }
    }
    var enemyDict: [Int : String] = [1: "Slime" , 2: "Bat"]
    var enemyDifficultyDict: [Int : enemyDifficultyLevel] = [1: .Lowest , 2: .Lower , 3: .Middle , 4: .Higher , 5: .Highest]
    

    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        multipleTouchEnabled = true
        buttonRight.userInteractionEnabled = false
        buttonRight.highlighted = true
        buttonLeft.userInteractionEnabled = false
        buttonContinue.userInteractionEnabled = false
//MARK: DebugDraw
        gamePhysicsNode.debugDraw = true
        gamePhysicsNode.collisionDelegate = self
        
        room = CCBReader.load("Rooms/Room\(roomNumber)", owner: self)
        roomNode.addChild(room)
        
        character.position = ccp(300, 150)
        
        healthLabel.string = "\(character.health) / \(character.maxHealth)"
        
        actionFollow = CCActionFollow(target: character, worldBoundary: background.boundingBox())
        contentNode.runAction(actionFollow)
        
        setSpecialDoor()
        generateEnemies()
    }

    
//MARK: Collisions
    
    //character and coin collision
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterBody: CCSprite!, coin: Coin!) -> Bool {
        coinCount++
        coinLabel.string = "\(coinCount)"
        if coin.notCollected{
            coin.collect()
        }
        return true
    }

    //sword and coin collision
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterSword: CCSprite!, coin: Coin!) -> Bool {
        return false
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterBody: Character!, food: Food!) -> Bool {
        food.physicsBody.sensor = true
        if character.health < character.maxHealth {
            character.health += 1
            healthLabel.string = "\(character.health) / \(character.maxHealth)"
        } else {
            food.removeFromParent()
            return false
        }
        food.removeFromParent()
        return false
    }
    
    //sword and enemy collision
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterSword: CCSprite!, enemy: Enemy!) -> Bool {
        if enemy != nil && enemy.enemyCollisionHappening == false {
            enemy.enemyCollisionHappening = true
            if character.damage >= enemy.health {
                //add score
                scoreCount += 10
                scoreLabel.string = "\(scoreCount)"
                
                //sometimes spawn coin when enemy dies
                var random = CCRANDOM_0_1()
                if random <= 0.4 {
                    var newCoin = CCBReader.load("Coin") as! Coin
                    newCoin.position = enemy.position
                    newCoin.scale = 0.3
                    roomNode.addChild(newCoin)
                } else if random <= 0.5 {
                    var newFood = CCBReader.load("Food") as! Food
                    newFood.position = enemy.position
                    newFood.scale = 0.4
                    roomNode.addChild(newFood)
                }
                
                enemy.removeFromParent()
                enemy.enemyCollisionHappening = false
                return false
            }
                
            else {
                enemy.health -= character.damage
                if character.characterState == .Left {
                    enemy.physicsBody.applyImpulse(ccp(-100, 100))
                } else {
                    enemy.physicsBody.applyImpulse(ccp(100,100))
                }
                enemy.enemyCollisionHappening = false
                return true
            }
        }
        enemy.enemyCollisionHappening = false
        return false
    }
    
    
    //character body and enemy collision
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterBody: CCSprite!, enemy: Enemy!) -> Bool {
        if enemy != nil && enemy.enemyCollisionHappening == false {
            enemy.enemyCollisionHappening = true
            //nothing happens if character is invulnerable
            if character.invulnerable == true {
                return false
            }
            
            //knock character backwards and limit how far he is hit
            if character.characterState == .Right {
                character.physicsBody.applyImpulse(ccp(100, 100))
            } else {
                character.physicsBody.applyImpulse(ccp(-100, 100))
            }
            character.physicsBody.velocity.x = CGFloat(clampf(Float(character.physicsBody.velocity.x), Float(-100), Float(100.0)))
            character.physicsBody.velocity.y = CGFloat(clampf(Float(character.physicsBody.velocity.y), Float(0), Float(100.0)))
            
            //make the character take damage and die if takes too much
            character.health -= enemy.damage
            characterHitFlag = true
            healthLabel.string = "\(character.health) / \(character.maxHealth)"
            println(character.health)
            
            //        if character.health <= 0 {
            //            userInteractionEnabled = false
            //            self.paused = true
            //
            //            var gameOverScreen = CCBReader.load("GameOver", owner: self) as! GameOver
            //            self.addChild(gameOverScreen)
            //        }
            
            //enable invulnerability for set amount of time on hit
            character.becomeInvulnerable()
            var invulnerableTime = CCActionDelay(duration: 1)
            var changeInvulnerableState = CCActionCallFunc(target: character, selector: "endInvulnerable")
            runAction(CCActionSequence(array: [invulnerableTime, changeInvulnerableState]))
            enemy.enemyCollisionHappening = false
            return true
        }
        return true
        
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterContainerNode: CCSprite!, ground: CCSprite!) -> Bool {
        character.jumpsLeft = character.maxJumps
        return true
    }
    
    //character body and door collision
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterBody: CCSprite!, door: Door!) -> Bool {
        replaceJumpWithContinue()
        
        currentDoor = door
        
        return false
    }
    
    //character moves away from door
    func ccPhysicsCollisionSeparate(pair: CCPhysicsCollisionPair!, characterBody: CCSprite!, door: Door!) {
        replaceContinueWithJump()
        
        currentDoor = nil
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, enemy: Enemy!, ground: CCSprite!) -> Bool {
        if enemy != nil && enemy.enemySubType == .Grounded {
            enemy.currentGroundReference = ground
            enemy.numberOfGroundPieces += 1
        }
        return true
    }
    
    func ccPhysicsCollisionSeparate(pair: CCPhysicsCollisionPair!, enemy: Enemy!, ground: CCSprite!) {
        if enemy != nil && enemy.enemySubType == .Grounded {
            enemy.numberOfGroundPieces -= 1
        }
    }
    
//MARK: buttons
    func turnLeft() {
        character.characterState = .Left
    }

    func turnRight() {
        character.characterState = .Right
    }
    
    func jump() {
        if character.jumpsLeft > 0 {
            character.physicsBody.applyImpulse(ccp(0, 400))
            character.jumpsLeft -= 1
        }
    }
    
    func enterDoor() {
        if currentDoor!.currentDoorState == .PlusOne {
            levelNumber += 1
            println(levelNumber)
            println(currentDoor!.doorLabel.string)
        } else if currentDoor!.currentDoorState == .PlusThree {
            levelNumber += 3
            println(levelNumber)
        } else if currentDoor!.currentDoorState == .PlusFive {
            levelNumber += 5
            println(levelNumber)
        } else if currentDoor!.currentDoorState == .Exit {
            self.paused = true
            exitDungeonLayer = CCBReader.load("ExitDungeon", owner: self)
            self.addChild(exitDungeonLayer)
            return
        }
            //special will be implemented later on
        else if currentDoor!.currentDoorState == .Special {
            levelNumber += levelNumber % 10
        }
        
        loadNextLevel()
    }

//MARK: Game Over Button Methods
    func returnToMenu() {
        character.health = character.maxHealth
        
        userInteractionEnabled = true
        removeChildByName("GameOver")
        let mainScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(mainScene)
    }
    
    func retryDungeon() {
        character.health = character.maxHealth
        
//        userInteractionEnabled = true
//        removeChildByName("GameOver")
        let gamePlayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gamePlayScene)
    }
    
    func goToStore() {
        let storeScene = CCBReader.loadAsScene("Store")
        CCDirector.sharedDirector().presentScene(storeScene)
    }
//MARK: Exit dungeon methods
    func yesExitDungeon() {
        totalCoins = coinCount
        goToStore()
    }
    
    func noExitDungeon() {
        exitDungeonLayer.removeFromParent()
        self.paused = false
    }
    
//MARK: level load functions
    func setCharacterPosition(nextLevel: Int) {
        if nextLevel == 1 || nextLevel == 2 {
            character.position = ccp(150, 150)
        }
        if nextLevel == 3 {
            character.position = ccp(150, 270)
        }
    }
    
    func setSpecialDoor() {
        if (levelNumber % 20) >= 15 {
            doors.doorSpecial.visible = true
        } else {
            doors.doorSpecial.visible = false
            doors.doorSpecial.physicsBody = nil
        }
    }
    
    func loadNextLevel() {
        roomNode.removeAllChildren()
        room.removeFromParent()
        //new value
        let nextRoomNumber = Int(arc4random_uniform(UInt32(totalRooms)) + 1)
        println("NextRoomNumber: \(nextRoomNumber)")
        room = CCBReader.load("Rooms/Room\(nextRoomNumber)", owner: self)
        roomNode.addChild(room)
        
        actionFollow = CCActionFollow(target: character, worldBoundary: background.boundingBox())
        contentNode.runAction(actionFollow)
        roomNumber = nextRoomNumber
        
        //reset jump
        character.jumpsLeft = character.maxJumps
        
        setCharacterPosition(nextRoomNumber)
        generateEnemies()
        setSpecialDoor()
        println("jumps left on loadNextLevel: \(character.jumpsLeft)")
    }
    
    func generateEnemies() {
        var increaseEnemyCount = UInt32((levelNumber % 20) / 2)
        var randomEnemyCount: UInt32 = 0
        var groundHeight = groundPiece.contentSize.height
        var groundWidth = groundPiece.contentSize.width
        var backgroundHeight = background.contentSize.height
        var backgroundWidth = background.contentSize.width
        
        //decide how many enemies will be generated on entering the level
        if roomNumber == 1 {
            randomEnemyCount = arc4random_uniform(5) + 2
        } else if roomNumber == 2 {
            randomEnemyCount = arc4random_uniform(5) + 5
        } else {
            randomEnemyCount = arc4random_uniform(10) + 20
        }
        randomEnemyCount += increaseEnemyCount
        randomEnemyCount = 20
        println("increase enemy count: \(increaseEnemyCount)")
        println("Enemies loaded into room: \(randomEnemyCount)")
        
        //create however many enemies are in randomEnemyCount
        for enemyNumber in 0...randomEnemyCount {
            var randomEnemyTypeNumber = Int(arc4random_uniform(UInt32(totalEnemyTypes)) + 1)
            var chanceOfHigherDifficulty = arc4random_uniform(UInt32(2))
            var raiseDifficultyCurve = Int(levelNumber / 20)
            var enemyDifficultyFinal = 1
            
            //place enemy
            var enemyXPosition = CGFloat(arc4random_uniform(UInt32(backgroundWidth - groundWidth)) + UInt32(groundWidth))
            var enemyYPosition = CGFloat(arc4random_uniform(UInt32(backgroundHeight - groundHeight)) + UInt32(groundHeight))
            var enemySpawnPoint = ccp((enemyXPosition), (enemyYPosition))
            var spawnedEnemy = CCBReader.load("Enemies/Slime") as! Enemy
            
            //optional unwrapping for string to find enemy file
            //            if let enemyFileTypeString = enemyDict[randomEnemyTypeNumber] {
            //                spawnedEnemy = CCBReader.load("Enemies/\(enemyFileTypeString)") as! Enemy
            //
            //            //allEnemiesSingleton.sharedInstance.allEnemies?.append(spawnedEnemy)
            //            }
            
            //set the difficulty level of the enemies
            if ((levelNumber % 20) / 10) >= 1 {
                enemyDifficultyFinal += Int(chanceOfHigherDifficulty) + raiseDifficultyCurve
            } else {
                enemyDifficultyFinal += raiseDifficultyCurve
            }
            
            //assign enemy difficulty with decided number
            if let enemyDiff = enemyDifficultyDict[enemyDifficultyFinal] {
                spawnedEnemy.enemyDifficulty = enemyDiff
                println("enemyDifficultyFinal: \(enemyDifficultyFinal) and enemyDifficultyDict: \(enemyDifficultyDict[enemyDifficultyFinal])")
            }
            
            //adjust enemy position in case it is on top of another enemy or the character on spawn
            //            if background.boundingBox().contains(enemySpawnPoint)
            
            spawnedEnemy.characterReference = character
            spawnedEnemy.backgroundReference = background
            spawnedEnemy.position = enemySpawnPoint
            
            room.addChild(spawnedEnemy)
        }
        
    }
    
//MARK: Misc
    
    func replaceJumpWithContinue() {
        buttonContinue.visible = true
        buttonContinue.userInteractionEnabled = true
        
        buttonJump.visible = false
        buttonJump.userInteractionEnabled = false
    }
    
    func replaceContinueWithJump() {
        buttonContinue.visible = false
        buttonContinue.userInteractionEnabled = false
        
        buttonJump.visible = true
        buttonJump.userInteractionEnabled = true
    }
    

    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        touchMoved(touch, withEvent: event)
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let touchLocation = touch.locationInNode(buttonNode)
        
        //implementation for left button
        if CGRectContainsPoint(buttonLeft.boundingBox(), touchLocation) {
            buttonLeft.highlighted = true
            buttonRight.highlighted = false
            turnLeft()
        }
        
        //implementation for right button
        if CGRectContainsPoint(buttonRight.boundingBox(), touchLocation) {
            buttonRight.highlighted = true
            buttonLeft.highlighted = false
            turnRight()
        }
    }
    
//MARK: update
    override func update(delta: CCTime) {
        //constant movement
        if character.characterState == .Right {
            character.runRight()
        } else if character.characterState == .Left {
            character.runLeft()
        }
        
        //check for character is at left boundary
        if character.position.x <= 10 {
            character.canMoveLeft = false
        }
        else if character.position.x >= 10 {
                character.canMoveLeft = true
            }
        
        //check for if character is at right boundary
        if character.position.x >= background.boundingBox().width - 10 {
            character.canMoveRight = false
            
        }
        else if character.position.x <= background.boundingBox().width - 10 {
            character.canMoveRight = true
        }

        
        //check if character is under the level
        if character.position.y <= background.boundingBox().origin.y {
            userInteractionEnabled = false
            
            self.paused = true
            var gameOverScreen = CCBReader.load("GameOver", owner: self) as! GameOver
            self.addChild(gameOverScreen)
        }
        
    }
}
