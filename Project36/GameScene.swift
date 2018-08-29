//
//  GameScene.swift
//  Project36
//
//  Created by Charles Martin Reed on 8/29/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //MARK:- Properties
    var player: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    
    
    override func didMove(to view: SKView) {
        //set up the gravity and establish the scene as a messenger for contact events
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        physicsWorld.contactDelegate = self
        
        createPlayer()
        createSky()
        createBackground()
        createGround()
        startRocks()
        createScore()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //neutralize any existing velocity the player might have between touches
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        //push the player upward by 20 points each tap
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
    }
    
    override func update(_ currentTime: TimeInterval) {
        //tilt the plane in a given direction as the player taps the screen
        let value = player.physicsBody!.velocity.dy * 0.001
        let rotate = SKAction.rotate(byAngle: value, duration: 0.1)
        
        player.run(rotate)
    }
    
    //MARK:- COMPOSED METHODS
    //This means "make each method do one small thing, then combine those things togther as needed"
    
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        scoreLabel.fontSize = 24
        
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 60)
        scoreLabel.text = "SCORE: 0"
        scoreLabel.fontColor = UIColor.black
        
        addChild(scoreLabel)
    }
    
    func createPlayer() {
        //create a sprite node - using a texture because we'll be animating the plane by swapping out images to make it appear that the propeller is turning
        let playerTexture = SKTexture(imageNamed: "player-1")
        player = SKSpriteNode(texture: playerTexture)
        player.zPosition = 10
        player.position = CGPoint(x: frame.width / 6, y: frame.height * 0.75)
        
        addChild(player)
        
        //setting up the physics for the player instance
        //create pixel-perfect physics using plane sprite
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: playerTexture.size())
        
        //tell us whenever the plane collides with anything
        //contact means two things touched, collision means two things BOUNCED OFF of each other
        //since the plane will bounce off of nothing, this means that we'll be notified when the player hits ANYTHING.
        player.physicsBody!.contactTestBitMask = player.physicsBody!.collisionBitMask
        
        //ensures that the plane will respond to physics
        player.physicsBody?.isDynamic = true
        
        //this would prevent the plane from bouncing off of objects; collide instead
        player.physicsBody?.collisionBitMask = 0
        
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
            ground.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: groundTexture.size().height / 2)
            
            //add physics for the ground
            ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.texture!.size())
            ground.physicsBody?.isDynamic = false
            
            addChild(ground)
            
            let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 5)
            let moveReset = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            ground.run(moveForever)
        }
    }
    
    func createRocks() {
        //Create top and bottom rock sprites. The top one is rotated and flipped horizontally.
        let rockTexture = SKTexture(imageNamed: "rock")
        
        let topRock = SKSpriteNode(texture: rockTexture)
        
        //Physics for the topRock
        topRock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
        topRock.physicsBody?.isDynamic = false
        
        topRock.zRotation = .pi
        //stretch the sprite, horiztontally. Here, we stretch the sprite by -100%, which inverts it.
        topRock.xScale = -1.0
        
        let bottomRock = SKSpriteNode(texture: rockTexture)
        
        //Physics for the bottomRock
        topRock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rockTexture.size())
        topRock.physicsBody?.isDynamic = false
        topRock.zPosition = -20
        bottomRock.zPosition = -20
        
        //Create a third sprite that is a large red rectangle (will make invisible later), positioned after the rocks and used to track when the player has passed through the rocks safely. Touch the rectangle, scroe a point.
        let rockCollision = SKSpriteNode(color: UIColor.red, size: CGSize(width: 32, height: frame.height))
        
        //Physics for the score detection flag
        rockCollision.physicsBody = SKPhysicsBody(rectangleOf: rockCollision.size)
        rockCollision.physicsBody?.isDynamic = false
        
        rockCollision.name = "scoreDetect"
        
        
        
        addChild(topRock)
        addChild(bottomRock)
        addChild(rockCollision)
        
        
        //Use GKRandomDistribution to generate a random number in a range. Used to determine a safe gap for where the rocks should be.
        let xPosition = frame.width + topRock.frame.width
        
        let max = Int(frame.height / 3)
        let rand = GKRandomDistribution(lowestValue: -50, highestValue: max)
        let yPosition = CGFloat(rand.nextInt())
        
        //adjust this to smaller value for more difficult game
        let rockDistance: CGFloat = 70
        
        //Position the rocks just off the right edge of the screen, then animate them across to the left edge. Remove from game once they exceed the left edge.
        topRock.position = CGPoint(x: xPosition, y: yPosition + topRock.size.height + rockDistance)
        bottomRock.position = CGPoint(x: xPosition, y: yPosition - rockDistance)
        rockCollision.position = CGPoint(x: xPosition + (rockCollision.size.width * 2), y: frame.midY)
        
        let endPosition = frame.width + (topRock.frame.width * 2)
        
        let moveAction = SKAction.moveBy(x: -endPosition, y: 0, duration: 6.2)
        let moveSequence = SKAction.sequence([moveAction, SKAction.removeFromParent()])
        topRock.run(moveSequence)
        bottomRock.run(moveSequence)
        rockCollision.run(moveSequence)
        
    }
    
    func startRocks() {
        //we want rocks to be created every few seconds, continuously until the player dies.
        let create = SKAction.run {
            [unowned self] in
            self.createRocks()
        }
        
        //we'll have a brief waiting period between creating new rocks
        let wait = SKAction.wait(forDuration: 3)
        let sequence = SKAction.sequence([create, wait])
        let repeatForever = SKAction.repeatForever(sequence)
        
        run(repeatForever)
    }
    
    //MARK: - Contact detection
    func didBegin(_ contact: SKPhysicsContact) {
        //check if they player hit the score node
        if contact.bodyA.node?.name == "scoreDetect" || contact.bodyB.node?.name == "scoreDetect" {
            if contact.bodyA.node == player {
                //if the player hits it, remove the score detection from the node tree
                contact.bodyB.node?.removeFromParent()
            } else {
                //the score detection node collided with the player, which is not what we want, so remove the player
                contact.bodyA.node?.removeFromParent()
            }
            
            let sound = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
            run(sound)
            
            score += 1
            
            //this is here because we want to destroy the player if they collide with ANYTHING ELSE
            return
        }
        
        //prevents the bodyA hits bodyB AND bodyB hits bodyA problem. This way, when the scoreDetect node is set to nil after initial collision, we'll return if the system registers a secondary hit.
        guard contact.bodyA.node != nil && contact.bodyB.node != nil else { return }
        
        //we'll only hit this code if what we made contact with wasn't a scoreDetect rectangle
        if contact.bodyA.node == player || contact.bodyB.node == player {
            if let explosion = SKEmitterNode(fileNamed: "PlayerExplosion") {
                explosion.position = player.position
                addChild(explosion)
            }
            
            let sound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
            run(sound)
            
            player.removeFromParent()
            //inherited by everything in our scene, determins how fast actions attached to a node should run. Realtime is 1.0, twice as fast is 2.0.
            //this has the effect of halting all those move actions we added to create our scrolling effect
            speed = 0
        }
        
        }
    }
