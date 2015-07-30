import Foundation

class MainScene: CCNode {
    
    var playButton: CCButton!
    
    
    func play() {
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
    }
    
    func store() {
        let storeScene = CCBReader.loadAsScene("Store")
        CCDirector.sharedDirector().presentScene(storeScene)
    }
}
