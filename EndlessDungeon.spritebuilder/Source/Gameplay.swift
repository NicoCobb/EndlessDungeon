
//
//  Gameplay.swift
//  EndlessDungeon
//
//  Created by nico cobb on 7/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

enum levelDifficulty {
    case ZeroToNine, TenToNinteen, TwentyToTwentyNine, ThirtyToThirtyNine, FortyToFortyNine, FiftyToFiftyNine, SixtyToSixtyNine, SeventyToSeventyNine, EightyToEightyNine, NinetyToNinetyNine
}

class Gameplay: CCNode, CCPhysicsCollisionDelegate {
    
    weak var roomNode: CCNode!
    weak var contentNode: CCNode!
    weak var buttonNode: CCNode!
    weak var gamePhysicsNode: CCPhysicsNode!
    
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
    
    var coinCount = 0
    var scoreCount = 0
    var levelNumber = 1
    var roomNumber = 3
    var totalRooms = 3
    var totalEnemyTypes = 2
    var actionFollow: CCActionFollow?
    var currentDoor: Door?
    var room: CCNode!
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
            return false
        }
        food.removeFromParent()
        return false
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterSword: CCSprite!, food: Food!) -> Bool {
        return false
    }
    
    //sword and enemy collision
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterSword: CCSprite!, enemy: Enemy!) -> Bool {
        if enemy != nil && enemy.enemyCollisionHappening == false {
            enemy.enemyCollisionHappening = true
            println("did collide with sword")
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
                    gamePhysicsNode.addChild(newCoin)
                } else if random <= 0.6 {
                    var newFood = CCBReader.load("Food") as! Food
                    newFood.position = enemy.position
                    newFood.scale = 0.4
                    gamePhysicsNode.addChild(newFood)
                }
                
                enemy.removeFromParent()
                enemy.enemyCollisionHappening = false
                return false
            }
                
            else {
                enemy.health -= character.damage
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
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, characterBody: CCSprite!, ground: CCSprite!) -> Bool {
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
            levelNumber = 1
        }
            //special will be implemented later on
        else if currentDoor!.currentDoorState == .Special {
            levelNumber += levelNumber % 10
        }
        
        roomNumber++
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
    
    
//MARK: Misc

    func showRoom() {
        let actionMoveToLevel = CCActionMoveTo(duration: 1, position: CGPoint(x: -(background.boundingBox().origin.x), y: 0.0))
        //        contentNode.runAction(actionMoveToLevel)
        
        // contentNode.stopAction(actionMoveToLevel)
        
        let actionMoveToStart = CCActionMoveTo(duration: 1, position: CGPoint.zeroPoint)
        //        contentNode.runAction(actionMoveToStart)
        
        let sequence = CCActionSequence(array: [actionMoveToLevel,actionMoveToStart])
        runAction(sequence)
    }
    
    func setCharacterPosition(nextLevel: UInt32) {
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
        room.removeFromParent()
        //new value
//        let nextRoomNumber = arc4random_uniform(UInt32(totalRooms)) + 1
        let nextRoomNumber: UInt32 = 3
        println("NextRoomNumber: \(nextRoomNumber)")
        room = CCBReader.load("Rooms/Room\(nextRoomNumber)", owner: self)
        roomNode.addChild(room)
        
        actionFollow = CCActionFollow(target: character, worldBoundary: background.boundingBox())
        contentNode.runAction(actionFollow)
        
        setCharacterPosition(nextRoomNumber)
        generateEnemies()
        setSpecialDoor()
        showRoom()
    }
    
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
    
    func generateEnemies() {
        var increaseEnemyCount = UInt32((levelNumber % 20) / 2)
        var randomEnemyCount: UInt32
        
        if roomNumber == 1 {
            randomEnemyCount = arc4random_uniform(UInt32(5)) + 2
        } else if roomNumber == 2 {
            randomEnemyCount = arc4random_uniform(UInt32(5)) + 5
        } else {
            randomEnemyCount = arc4random_uniform(UInt32(10)) + 20
        }
        randomEnemyCount += increaseEnemyCount
        
        
        for enemyNumber in 0...randomEnemyCount {
            var randomEnemyTypeNumber = Int(arc4random_uniform(UInt32(totalEnemyTypes)) + 1)
            var chanceOfHigherDifficulty = arc4random_uniform(UInt32(levelNumber % 2))
            var raiseDifficultyCurve = Int(levelNumber / 20)
            var enemyDifficultyFinal = 0
            
            var groundHeight = groundPiece.contentSize.height
            var groundWidth = groundPiece.contentSize.width
            var backgroundHeight = background.contentSize.height
            var backgroundWidth = background.contentSize.width
            var enemyXPosition: UInt32
            var enemyYPosition: UInt32
            var enemySpawnPoint: CGPoint
            var spawnedEnemy = CCBReader.load("Enemies/Slime") as! Enemy
            var enemyDict: [Int : String] = [1: "Slime" , 2: "Bat"]
            var enemyDifficultyDict: [Int : enemyDifficultyLevel] = [1: .Lowest , 2: .Lower , 3: .Middle , 4: .Higher , 5: .Highest]
            
            //optional unwrapping for string to find enemy file
            if let enemyFileTypeString = enemyDict[randomEnemyTypeNumber] {
                println(enemyFileTypeString)
                spawnedEnemy = CCBReader.load("Enemies/\(enemyFileTypeString)") as! Enemy
            //allEnemiesSingleton.sharedInstance.allEnemies?.append(spawnedEnemy)
            }
            
            //set the difficulty level of the enemies
            if ((levelNumber % 20) / 10) >= 1 {
                enemyDifficultyFinal = Int(chanceOfHigherDifficulty) + raiseDifficultyCurve
            } else {
                enemyDifficultyFinal = raiseDifficultyCurve
            }
            

            //place enemy
                enemyXPosition = arc4random_uniform(UInt32(backgroundWidth - groundWidth)) + UInt32(groundWidth)
                enemyYPosition = arc4random_uniform(UInt32(backgroundHeight - groundHeight)) + UInt32(groundHeight)
                enemySpawnPoint = ccp(CGFloat(enemyXPosition), CGFloat(enemyYPosition))
            
            //adjust enemy position in case it is on top of another enemy or the character on spawn
//            if background.boundingBox().contains(enemySpawnPoint)
            
            spawnedEnemy.characterReference = character
            spawnedEnemy.backgroundReference = background
            spawnedEnemy.position = enemySpawnPoint
            if let enemyDiff = enemyDifficultyDict[enemyDifficultyFinal] {
                spawnedEnemy.enemyDifficulty = enemyDiff
            }
            
            
            gamePhysicsNode.addChild(spawnedEnemy)
        }
        
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
        if character.position.y <= background.boundingBox().height {
            userInteractionEnabled = false
            self.paused = true
            
            var gameOverScreen = CCBReader.load("GameOver", owner: self) as! GameOver
            self.addChild(gameOverScreen)
        }
        
    }
}
