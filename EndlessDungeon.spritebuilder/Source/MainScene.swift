import Foundation

class MainScene: CCNode {
    
    var playButton: CCButton!
    
    
    func play() {
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
    }
}
