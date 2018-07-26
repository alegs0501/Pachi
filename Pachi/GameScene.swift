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
    private var score = 0
    private var scoreLabel: SKLabelNode?
    
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
        
        //Creating Score
        scoreLabel = SKLabelNode(text: "scoreLabel")
        scoreLabel!.fontSize = 100
        scoreLabel!.fontColor = SKColor.white
        scoreLabel!.text = "\(score)"
        scoreLabel!.position = CGPoint(x: frame.size.width * 0.9 / 2, y: frame.size.height * 0.8 / 2)
        self.addChild(scoreLabel!)
        
        //Creating blades
        makeBlades(at: CGPoint(x: 0, y: 0),clockwise:  true)
        makeBlades(at: CGPoint(x: -200, y: -60), clockwise:  false)
        makeBlades(at: CGPoint(x: 200, y: -60), clockwise:  true)
        makeBlades(at: CGPoint(x: -350, y: -85), clockwise:  true)
        makeBlades(at: CGPoint(x: 350, y: -85), clockwise:  false)
    
        
        
    }
    
    //Making bouncer
    func makeBouncer(at position: CGPoint) {
        //Bouncer
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width/2)
        bouncer.physicsBody?.isDynamic = false
        bouncer.zPosition = 1
        addChild(bouncer)
    }
    
    //Making slot
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
    
    //Making blades
    func makeBlades(at position: CGPoint, clockwise: Bool) {
        
        let blades = SKSpriteNode(imageNamed: "blades")
        let bladesTexture = SKTexture(imageNamed: "blades.png")
        var spin = SKAction()
        

        blades.position = position
        
        //Adjusting collision to sprite with a texture
        blades.physicsBody = SKPhysicsBody(texture: bladesTexture,
                                                      size: CGSize(width: blades.size.width,
                                                                   height: blades.size.height))
        blades.physicsBody?.isDynamic = false
        
        //Definig rotation
        if clockwise {
            spin = SKAction.rotate(byAngle: -CGFloat.pi, duration: 2)
        }else {
            spin = SKAction.rotate(byAngle: CGFloat.pi, duration: 2)
            
        }
        
        let spinForever = SKAction.repeatForever(spin)
        blades.run(spinForever)
        addChild(blades)
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
            //let ball = SKSpriteNode(imageNamed: "ballRed")
            var ball = SKSpriteNode()
            switch score {
            case 0...10:
                ball = SKSpriteNode(imageNamed: "ballRed")
            case 11...61:
                ball = SKSpriteNode(imageNamed: "ballGreen")
            case 62...165:
                ball = SKSpriteNode(imageNamed: "ballPurple")
            case 165...1000:
                ball = SKSpriteNode(imageNamed: "ballYellow")
            default:
                ball = SKSpriteNode(imageNamed: "ballRed")
            }
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.height/2)
            
            ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
            
            ball.physicsBody?.restitution = 0.65
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
            ratingScore(plus: true, score: score)
            destroy(object: ball)
            scoreLabel?.text = "\(score)"
        }else if object.name == "bad"{
            ratingScore(plus: false, score: score)
            destroy(object: ball)
            scoreLabel?.text = "\(score)"
        }
        
    }
    
    func destroy(object: SKNode){
        object.removeFromParent()
    }
    
    //Calculating rating score
    func ratingScore(plus: Bool, score: Int) {
        if plus {
            switch score {
            case 0...10:
                self.score += 1
            case 11...61:
                self.score += 5
            case 62...165:
                self.score += 10
            case 165...1000:
                self.score += 15
            default:
                self.score = score
            }
        }else{
            if score != 0{
                switch score {
                case 0...10:
                    self.score -= 1
                case 11...61:
                    self.score -= 3
                case 62...165:
                    self.score -= 7
                case 165...1000:
                    self.score -= 10
                default:
                    self.score = score
                }
            }
        }
        
    }
    
}
