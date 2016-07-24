import Foundation

class MainScene: CCNode {
    
    weak var playButton: CCButton!
    
    func play() {
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
    }
    
    func store() {
        let storeScene = CCBReader.loadAsScene("Store/Store")
        CCDirector.sharedDirector().presentScene(storeScene)
    }
}
