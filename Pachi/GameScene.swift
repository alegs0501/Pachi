//
//  GameScene.swift
//  Pachi
//
//  Created by CICE on 20/7/18.
//  Copyright © 2018 alegs0501. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //CollisionBitMask -> What objects can collide
    //ContactTestBitMask -> Dice que objeto lanza alerta de colision
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        //Setting delegate
        physicsWorld.contactDelegate = self
        
        //World´s physics
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        //Creating a node
        let backgroundNode = SKSpriteNode(imageNamed: "background.jpg")
        //Putting node in position
        backgroundNode.position = CGPoint(x: 0, y: 0)
        //Defining blendmode
        backgroundNode.blendMode = .replace
        //Defining position in z axis
        backgroundNode.zPosition = -1
        //Adding node to view
        addChild(backgroundNode)
        
        //Create 4 bouncer
        makeBouncer(at: CGPoint(x: -512, y: -390))
        makeBouncer(at: CGPoint(x: -256, y: -390))
        makeBouncer(at: CGPoint(x: 0, y: -390))
        makeBouncer(at: CGPoint(x: 256, y: -390))
        makeBouncer(at: CGPoint(x: 512, y: -390))
        
        //Create 4 slots
        makeSlot(at: CGPoint(x:-384, y:-384), isGood: true)
        makeSlot(at: CGPoint(x:-128, y:-384), isGood: false)
        makeSlot(at: CGPoint(x:128, y:-384), isGood: true)
        makeSlot(at: CGPoint(x:384, y:-384), isGood: false)
        
    }
    
    func makeBouncer(at position: CGPoint) {
        //Bouncer
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width/2)
        bouncer.physicsBody?.isDynamic = false
        bouncer.zPosition = 1
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool){
        var slotBase = SKSpriteNode()
        var slotGlow = SKSpriteNode()
        if isGood{
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        }else{
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        slotBase.position = position
        slotGlow.position = position
        slotGlow.zPosition = 0
        
        //Animating glows
            //Creating spriteKit Action
        let spin = SKAction.rotate(byAngle: CGFloat.pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotGlow)
        addChild(slotBase)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Getting first finger
        if let touch = touches.first{
            //Getting finger location
            let fingerLocation = touch.location(in: self)
            /*//Creating a box node
            let box = SKSpriteNode(color: UIColor.red, size: CGSize(width: 80, height: 80))
            //Physics body
            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 80, height: 80))
            box.position = fingerLocation
            addChild(box)*/
            
            //Creating color balls
            let ball = SKSpriteNode(imageNamed: "ballRed")
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.height/2)
            
            ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
            
            ball.physicsBody?.restitution = 0.4
            ball.position = fingerLocation
            ball.zPosition = 2
            ball.name = "ball"
            addChild(ball)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "ball"{
            collisionBetween(ball: contact.bodyA.node!, object: contact.bodyB.node!)
        }else if contact.bodyB.node?.name == "ball"{
            collisionBetween(ball: contact.bodyB.node!, object: contact.bodyA.node!)
        }
        
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good"{
            destroy(object: ball)
        }else if object.name == "bad"{
            destroy(object: ball)
        }
    }
    
    func destroy(object: SKNode){
        object.removeFromParent()
    }
    
}
