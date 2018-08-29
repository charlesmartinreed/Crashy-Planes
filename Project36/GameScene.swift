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
        createSky()
        createBackground()
        createGround()
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
    
    func createSky() {
        //we'll be creating the sky from colored nodes and changing their anchor points so that they are measured from the center top.
        let topSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.14, brightness: 0.97, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.67))
        topSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        let bottomSky = SKSpriteNode(color: UIColor(hue: 0.55, saturation: 0.16, brightness: 0.96, alpha: 1), size: CGSize(width: frame.width, height: frame.height * 0.33))
        bottomSky.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        topSky.position = CGPoint(x: frame.midX, y: frame.height)
        bottomSky.position = CGPoint(x: frame.midX, y: bottomSky.frame.height)
        
        addChild(topSky)
        addChild(bottomSky)
        
        bottomSky.zPosition = -40
        topSky.zPosition = -40
    }
    
    func createBackground(){
    //we need the mountains to scroll off the screen and leave nothing behind, so they have to scroll to the left indefinitiely. We'll do this by creating two sets of mountains, both moving left, and when one moves off screen, we'll move it all the way to the other side of the screen to start moving again.
        
        let backgroundTexture = SKTexture(imageNamed: "background")
        
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: backgroundTexture)
            
            //in front of the sky, which is -40
            background.zPosition = -30
            
            //position it from the left edge - background will be fully off the screen when the X position = 0 - background.size.width
            background.anchorPoint = CGPoint.zero
            
            //minus one to avoid any tiny little gaps between the mountain
            background.position = CGPoint(x: (backgroundTexture.size().width * CGFloat(i)) - CGFloat(1 * i), y: 100)
            addChild(background)
            
            //animate the mountains to move to the left by a distance equal to it's width over 20 seconds, then back to the right by the same amount, immediately.

            let moveLeft = SKAction.moveBy(x: -backgroundTexture.size().width, y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x: backgroundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            //loop the animation endlessly
            background.run(moveForever)
        }
    }
    
    func createGround() {
        //needs to have zPosition of -10 and a similar movement logic to the mountains. Can't adjust the anchor point since this screws with the physics and we need consistent physics for the collision detection.
        
        let groundTexture = SKTexture(imageNamed: "ground")
        
        for i in 0 ... 1 {
            let ground = SKSpriteNode(texture: groundTexture)
            ground.zPosition = -10
            ground.position = CGPoint(x: (groundTexture.size().width / 2 + (groundTexture.size().width * CGFloat(i))), y: groundTexture.size().height / 2)
            
            addChild(ground)
            
            let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 5)
            let moveReset = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            ground.run(moveForever)
        }
    }
}
