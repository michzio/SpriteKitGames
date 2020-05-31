//
//  GameScene.swift
//  ZombieConga
//
//  Created by Michal Ziobro on 24/05/2020.
//  Copyright © 2020 Michal Ziobro. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: - Properties
    var lives = 5
    var gameOver = false
    
    let playableRect: CGRect
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    var lastTouchLocation: CGPoint = .zero
    
    let zombie = SKSpriteNode(imageNamed: "zombie1")
    let zombiePointsPerSec: CGFloat = 480.0 // movement speed
    let zombieRadiansPerSec: CGFloat = 4.0 * π // rotation speed
    var velocity = CGVector.zero
    
    var zombieIsInvincible = false
    
    var zombieAnimation: SKAction!
    
    let catPointsPerSec: CGFloat = 480.0 // movement speed
    
    var hitCatSound = SKAction.playSoundFileNamed("hitCat.wav", waitForCompletion: false)
    var hitEnemySound = SKAction.playSoundFileNamed("hitCatLady.wav", waitForCompletion: false)
    
    // MARK: - Init
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight)/2.0
        
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
    
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
   
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        setupScene()
        setupZombie()
        
        animateZombie()
        
        spawnEnemies()
        spawnCats()
        
        debugDrawPlayableArea()
    }
    
    private func setupScene() {
        
        let background = SKSpriteNode(imageNamed: "background1")
        
        // (0,0) position is in bottom-left
        // in UIKit (0,0) is top-left
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        
        //background.zRotation = CGFloat(M_PI)/8
        
        addChild(background)
        
        
        let sizeOfSprite = background.size
        print("Size of sprite: \(sizeOfSprite)")
    }
    
    private func setupZombie() {
        
        zombie.position = CGPoint(x: 400, y: 400)
        zombie.setScale(1.0)
        zombie.zPosition = 100
        
        addChild(zombie)
    }
    
    // MARK: - Game Loop
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        print("\(dt*1000) milliseconds since last update")
        
        if( isZombieNearTouchLocation ) {
            zombie.position = lastTouchLocation
            velocity = .zero
            stopZombieAnimation()
        } else {
            move(sprite: zombie, velocity: velocity)
            rotate(sprite: zombie, direction: velocity)
        }
        
        boundsCheckZombie()
        
        // moved to didEvaluateActions to execute this after
        // actions evaluations, when sprites are at its proper positions
        // checkCollisions()
        
        moveTrain()
        
        checkLoseCondition()
    }
    
    override func didEvaluateActions() {
        checkCollisions()
    }
    
    private var isZombieNearTouchLocation: Bool {
        (zombie.position - lastTouchLocation).length() < zombiePointsPerSec*CGFloat(dt)
    }
    
    private func boundsCheckZombie() {
        
        let bottomLeft = CGPoint(x:0, y: playableRect.minY)
        let topRight = CGPoint(x: size.width, y: playableRect.maxY)
        
        if zombie.position.x <= bottomLeft.x {
            zombie.position.x = bottomLeft.x
            velocity.dx = -velocity.dx
        }
        
        if zombie.position.x >= topRight.x {
           zombie.position.x = topRight.x
           velocity.dx = -velocity.dx
        }
        
        if zombie.position.y <= bottomLeft.y {
           zombie.position.y = bottomLeft.y
            velocity.dy = -velocity.dy
        }
        
        if zombie.position.y >= topRight.y {
           zombie.position.y = topRight.y
            velocity.dy = -velocity.dy
        }
    }
    
    private func move(sprite: SKSpriteNode, velocity: CGVector) {
        
        //let amountToMove = CGVector(dx: velocity.dx * CGFloat(dt), dy: velocity.dy * CGFloat(dt))
        let amountToMove = velocity*CGFloat(dt)
        
        print("Amount to move: \(amountToMove)")
        
        //sprite.position = CGPoint(x: sprite.position.x + amountToMove.dx, y: sprite.position.y + amountToMove.dy)
        sprite.position += amountToMove
    }
    
    private func rotate(sprite: SKSpriteNode, direction: CGVector) {
        //sprite.zRotation = CGFloat(atan2(Double(direction.dy), Double(direction.dx)))
        
        // shortest angle between sprite direction and target direction
        let shortestRotateToTarget = shortestAngleBetween(angle1: sprite.zRotation, angle2: direction.angle)
        // possible amount to rotate per frame taking into account zombie rotation speed and time
        let amountToRotatePerFrame = zombieRadiansPerSec*CGFloat(dt)
        
        
        if abs(shortestRotateToTarget) < amountToRotatePerFrame {
            sprite.zRotation += shortestRotateToTarget
        } else {
            sprite.zRotation += amountToRotatePerFrame * shortestRotateToTarget.sign()
        }
    }
}

// MARK: - Touch Events
extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    func sceneTouched(touchLocation: CGPoint) {
        self.lastTouchLocation = touchLocation
        moveZombieToward(location: touchLocation)
    }
    
    func moveZombieToward(location: CGPoint) {
        let offset = CGVector(point: location - zombie.position)
        let direction = offset.normalized()
        
        velocity = direction*zombiePointsPerSec
        
        startZombieAnimation()
    }
}

// MARK: - Debug
extension GameScene {
    
    private func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
}

// MARK: - Enemy - Crazy Lady
extension GameScene {
   
    /* examples
    private func spawnEnemy() {
        
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.position = CGPoint(x: size.width + enemy.size.width/2, y: size.height/2)
        
        addChild(enemy)
        
        
        /* example 1
        let move = SKAction.move(to: CGPoint(x: -enemy.size.width/2, y: enemy.position.y), duration: 1.0)
        
        let midMove = SKAction.move(to: CGPoint(x: size.width/2, y: playableRect.minY + enemy.size.height/2), duration: 1.0)
        
        let wait = SKAction.wait(forDuration: 0.25)
        
        let log = SKAction.run {
             print("Reached bottom!")
        }
    
    
        let sequence = SKAction.sequence([midMove, log, wait, move])
        */
        
        /* example 2 */
        
        let midMove = SKAction.moveBy(x: -size.width/2 - enemy.size.width/2, y: -playableRect.height/2 + enemy.size.height/2, duration: 1.0)
        
        let move = SKAction.moveBy(x: -size.width/2 - enemy.size.width/2, y: playableRect.height/2 - enemy.size.height/2, duration: 1.0)
        
        let wait = SKAction.wait(forDuration: 0.25)
        
        let log = SKAction.run {
             print("Reached bottom!")
        }
        
        /*
        let sequence = SKAction.sequence([
            midMove, log, wait, move,
            move.reversed(), log, wait, midMove.reversed()
        ])
        */
        
        let halfSequence = SKAction.sequence([
            midMove, log, wait, move
        ])
        let sequence = SKAction.sequence([
            halfSequence, halfSequence.reversed()
        ])
        
    
        //enemy.run(sequence)
        
        let action = SKAction.repeatForever(sequence)
        
        enemy.run(action)
    } */
    
    private func spawnEnemy() {
        
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.name = "enemy"
        
        let rightX = size.width + enemy.size.width/2
        let randY = CGFloat.random(min: playableRect.minY + enemy.size.height/2, max: playableRect.maxY - enemy.size.height/2)
        enemy.position = CGPoint(x: rightX, y: randY)
        
        addChild(enemy)
        
        let move = SKAction.moveTo(x: -enemy.size.width/2, duration: 2.0)
        let remove = SKAction.removeFromParent()
        
        enemy.run(.sequence([move, remove]))
        
        //enemy.texture =
    }
    
    private func spawnEnemies() {
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run { [weak self] in
                    self?.spawnEnemy()
                },
                SKAction.wait(forDuration: 2.0)
            ])
        ))
    }
}

// MARK: - Zombie Animations
extension GameScene {
    
    private func animateZombie() {
        
        zombieAnimation = SKAction.animate(with: zombieTextures, timePerFrame: 0.1)
        
        /* changed to start/stopZombieAnimation()
           zombie.run(SKAction.repeatForever(zombieAnimation))
        */
    }

    private func startZombieAnimation() {
        
        if(zombie.action(forKey: "animation") == nil) {
            zombie.run(SKAction.repeatForever(zombieAnimation), withKey: "animation")
        }
    }
    
    private func stopZombieAnimation() {
        zombie.removeAction(forKey: "animation")
    }
    
    private var zombieTextures: [SKTexture] {
         
        var textures = [SKTexture]()
        
         for i in 1...4 {
             textures.append(SKTexture(imageNamed: "zombie\(i)"))
         }
         
         textures.append(textures[2])
         textures.append(textures[1])
         
        return textures
     }
    
    
}

// MARK: - Collectibles - Cats
extension GameScene {
    
    private func spawnCats() {
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run { [weak self] in self?.spawnCat() },
                SKAction.wait(forDuration: 1.0)
            ])
        ))
    }
    
    private func spawnCat() {
        
        let cat = SKSpriteNode(imageNamed: "cat")
        cat.name = "cat"
        
        let randX = CGFloat.random(in: playableRect.minX...playableRect.maxX)
        let randY = CGFloat.random(in: playableRect.minY...playableRect.maxY)
        cat.position = CGPoint(x: randX, y: randY)
        cat.zRotation = -π/16.0
        
        cat.setScale(0)
        
        addChild(cat)
        
        
        // Appear -> Disappear action sequence
        let appear = SKAction.scale(to: 1.0, duration: 0.5)
        
        //let wait = SKAction.wait(forDuration: 10.0)
        
        // Wiggle Wait > Rotation
        let leftWiggle = SKAction.rotate(byAngle: π/8.0, duration: 0.5)
        let rightWiggle = leftWiggle.reversed()
        let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle])
        //let wiggleWait = SKAction.repeat(fullWiggle, count: 10)
        
        // Scale Up/Down Wait > Scale
        let scaleUp = SKAction.scale(by: 1.2, duration: 0.25)
        let scaleDown = scaleUp.reversed()
        let fullScale = SKAction.sequence([scaleUp, scaleDown, scaleUp, scaleDown])
        //let scaleWait = SKAction.repeat(fullScale, count: 10)
        
        // Group Wiggle and Scale
        let group = SKAction.group([fullScale, fullWiggle])
        let groupWait = SKAction.repeat(group, count: 10)
    
        let disappear = SKAction.scale(to: 0.0, duration: 0.5)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([appear, groupWait, disappear, remove]) // wait, wiggleWait, scaleWait or groupWait
        
        cat.run(sequence)
        
    }
}

// MARK: - Collision Detection - Bounding Boxes
extension GameScene {
    
    private func zombieHit(cat: SKSpriteNode) {
        //cat.removeFromParent()
        
        cat.name = "train"
        cat.removeAllActions()
        cat.setScale(1.0)
        cat.zRotation = 0.0
        
        let action = SKAction.colorize(with: .green, colorBlendFactor: 1.0, duration: 0.2)
        
        cat.run(action)
        
        run(hitCatSound)
    }
    
    private func zombieHit(enemy: SKSpriteNode) {
        // do not remove cat lady
        //enemy.removeFromParent()
        
        lives -= 1
        makeZombieInvicible()

        loseCats()
        
        run(hitEnemySound)
    }
    
    private func makeZombieInvicible() {
        
        zombieIsInvincible = true
        
        let invicibleAction = SKAction.sequence([
            blinkAction,
            SKAction.run { [weak self] in
                self?.zombie.isHidden = false
                self?.zombieIsInvincible = false
            }
        ])
        
        zombie.run(invicibleAction)
    }
    
    private func checkCollisions() {
        
        var hitCats = [SKSpriteNode]()
        enumerateChildNodes(withName: "cat") { node, _ in
            let cat = node as! SKSpriteNode
            if cat.frame.intersects(self.zombie.frame) {
                hitCats.append(cat)
            }
        }
        for cat in hitCats {
            zombieHit(cat: cat)
        }
        
        
        var hitEnemies = [SKSpriteNode]()
        
        if zombieIsInvincible == false {
            enumerateChildNodes(withName: "enemy") { node, _ in
                let enemy = node as! SKSpriteNode
                if enemy.frame.insetBy(dx: 20, dy: 20).intersects(self.zombie.frame) {
                    hitEnemies.append(enemy)
                }
            }
        }
        for enemy in hitEnemies {
            zombieHit(enemy: enemy)
        }
    }
}

// MARK: - Invincible Zombie
extension GameScene {
    
    private var blinkAction: SKAction {
        
        let blinkTimes = 10.0
        let duration = 3.0
        let blinkAction = SKAction.customAction(withDuration: duration) { (node, elapsedTime) in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(dividingBy: slice)
            
            node.isHidden = remainder > slice/2
        }
        
        return blinkAction
    }
}

// MARK: - Conga line - Move Train
extension GameScene {
    
    private func moveTrain() {
        
        var trainCount = 0
        
        var targetPosition = zombie.position
        
        enumerateChildNodes(withName: "train") { (node, _) in
            
            if !node.hasActions() {
                let actionDuration = 0.3
                let offset : CGVector = (targetPosition - node.position).vector
                let direction = offset.normalized()
                let amountToMovePerSec = direction * self.catPointsPerSec
                let amountToMove = amountToMovePerSec * CGFloat(actionDuration)
                
                let moveAction = SKAction.move(by: amountToMove, duration: actionDuration)
                
                node.run(moveAction)
            }
            targetPosition = node.position
            
            trainCount += 1
        }
        
        checkWinCondition(for: trainCount)
    }
}

// MARK: - Lose Cats
extension GameScene {
    
    private func loseCats() {
        
        var loseCount = 0
        
        enumerateChildNodes(withName: "train") { node, stop in
            
            // remove from conga line
            node.name = ""
            
            // animate lost cat
            var randomSpot = node.position
            randomSpot.x += CGFloat.random(in: -100...100)
            randomSpot.y += CGFloat.random(in: -100...100)
            
            node.run(
                SKAction.sequence([
                    SKAction.group([
                        .rotate(byAngle: π*4, duration: 1.0),
                        .move(to: randomSpot, duration: 1.0),
                        .scale(to: 0.0, duration: 1.0)
                    ]),
                    SKAction.removeFromParent()
                ])
            )
            
            // increment lose count and check at least two cats lost
            loseCount += 1
            if loseCount >= 2 {
                stop[0] = true
            }
        }
    }
}

// MARK: Win/Lose conditions
extension GameScene {
    
    private func checkLoseCondition() {
        if lives <= 0 && !gameOver {
            gameOver = true
            print("You lose!")
        }
    }
    
    
    private func checkWinCondition(for trainCount: Int) {
        if trainCount >= 15 && !gameOver {
            gameOver = true
            print("You win!")
        }
    }
}
