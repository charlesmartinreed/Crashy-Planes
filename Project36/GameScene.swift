//
//  GameScene.swift
//  Project36
//
//  Created by Charles Martin Reed on 8/29/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    //MARK:- Properties
    var player: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        createPlayer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //do
    }
    
    //MARK:- COMPOSED METHODS
    //This means "make each method do one small thing, then combine those things togther as needed"
    
    func createPlayer() {
        //create a sprite node - using a texture because we'll be animating the plane by swapping out images to make it appear that the propeller is turning
        let playerTexture = SKTexture(imageNamed: "player-1")
        player = SKSpriteNode(texture: playerTexture)
        player.zPosition = 10
        player.position = CGPoint(x: frame.width / 6, y: frame.height * 0.75)
        
        addChild(player)
        
        //animating our player sprite - set to 0.01, which is faster than our screen draws so we're basically saying "as quickly as possible"
        let frame2 = SKTexture(imageNamed: "player-2")
        let frame3 = SKTexture(imageNamed: "player-3")
        let animation = SKAction.animate(with: [playerTexture, frame2, frame3], timePerFrame: 0.01)
        let runForever = SKAction.repeatForever(animation)
        
        player.run(runForever)
    }
}
