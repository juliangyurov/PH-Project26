//
//  GameScene.swift
//  Project26
//
//  Created by Yulian Gyuroff on 25.11.23.
//
import CoreMotion
import SpriteKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case teleport = 32
}
enum shapeType {
    case circle
    case rectangle
}

class GameScene: SKScene, SKPhysicsContactDelegate  {
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var motionManager: CMMotionManager!
    var scoreLabel: SKLabelNode!

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var isGameOver = false
    
    var teleportPositions = [CGPoint]()
    //var allNodes = [SKSpriteNode]()
     
    fileprivate func createScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
    }
    
    fileprivate func createBackGrnd() {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        physicsWorld.gravity = .zero
        
        createScoreLabel()
        
        createBackGrnd()
        
        loadLevel()
        createPlayer(position: CGPoint(x: 96, y: 672))
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
    }
    
    fileprivate func createNode(_ node: SKSpriteNode, _ position: CGPoint, _ nodeName: String,
                                _ shape: shapeType, _ isDynamic: Bool, _ categoryBitMask: UInt32,
                                _ contactTestBitMask: UInt32?, _ collisionBitMask: UInt32, _ rotate: Bool) {
        node.name = nodeName
        node.position = position
        
        if rotate {
            node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        }
        if shape == shapeType.circle {
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        }else{
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        }
        node.physicsBody?.isDynamic = isDynamic
        
        node.physicsBody?.categoryBitMask = categoryBitMask
        if !(contactTestBitMask == nil){
            node.physicsBody?.contactTestBitMask = contactTestBitMask ?? CollisionTypes.player.rawValue
        }
        node.physicsBody?.collisionBitMask = collisionBitMask
        //allNodes.append(node)
        addChild(node)
    }
    
    func loadLevel() {
        guard let levelURL = Bundle.main.url(forResource: "level1", withExtension: "txt") else {
            fatalError("Could not find level1.txt in the app bundle.")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not load level1.txt from the app bundle.")
        }

        let lines = levelString.components(separatedBy: "\n")

        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                //let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) - 32)

                if letter == "x" {
                    // load wall
                    let node = SKSpriteNode(imageNamed: "block")
                    node.position = position

                    node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                    node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
                    node.physicsBody?.isDynamic = false
                    //allNodes.append(node)
                    addChild(node)
                } else if letter == "v"  {
                    // load vortex
                    let node = SKSpriteNode(imageNamed: "vortex")
                    createNode(node, position, "vortex", shapeType.circle ,false,
                               CollisionTypes.vortex.rawValue,
                               CollisionTypes.player.rawValue,0,true)
                } else if letter == "s"  {
                    // load star
                    let node = SKSpriteNode(imageNamed: "star")
                    createNode(node, position, "star", shapeType.circle ,false,
                               CollisionTypes.star.rawValue,
                               CollisionTypes.player.rawValue,0,true)

                } else if letter == "f"  {
                    // load finish
                    let node = SKSpriteNode(imageNamed: "finish")
                    createNode(node, position, "finish", shapeType.circle ,false,
                               CollisionTypes.finish.rawValue,
                               CollisionTypes.player.rawValue,0,false)

                }else if letter == "t" {
                    // load wall
                    let node = SKSpriteNode(imageNamed: "teleport")
                    createNode(node, position, "teleport", shapeType.rectangle ,false,
                               CollisionTypes.teleport.rawValue,
                               CollisionTypes.player.rawValue,0,false)

                }else if letter == " " {
                    // this is an empty space – add to !
                    teleportPositions.append(position)
                } else {
                    fatalError("Unknown level letter: \(letter)")
                }
            }
        }
    }
    
    func createPlayer(position: CGPoint) {
        player = SKSpriteNode(imageNamed: "player")
        player.position = position
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5

        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue | CollisionTypes.teleport.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        //allNodes.append(player)
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        //        if let currentTouch = lastTouchPosition {
        //            let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
        //            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        //        }
#if targetEnvironment(simulator)
        if let currentTouch = lastTouchPosition {
            let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
#else
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
#endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1

            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])

            player.run(sequence) { [weak self] in
                self?.createPlayer(position: CGPoint(x: 96, y: 672))
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            // next level?
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score += 10

            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])

            player.run(sequence) { [weak self] in
                self?.teleportPositions.removeAll()
                
                self?.removeAllChildren()
                self?.createBackGrnd()
                self?.createScoreLabel()
                //self?.allNodes.removeAll()
                
                self?.loadLevel()
                self?.createPlayer(position: CGPoint(x: 96, y: 672))
                self?.isGameOver = false
            }
        }else if node.name == "teleport"{
            // teleport player
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score += 15

            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])

                     
            player.run(sequence) { [weak self] in
                                
                if self?.teleportPositions.count ?? 0 > 0 {
                    self?.createPlayer(position: (self?.teleportPositions.randomElement())! )
                }else {
                    self?.createPlayer(position: CGPoint(x: 96, y: 672) )
                }
                self?.isGameOver = false
            }
            
        }
    }
}
