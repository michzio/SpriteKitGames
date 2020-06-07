//
//  GameOverScene.swift
//  ZombieConga
//
//  Created by Michal Ziobro on 31/05/2020.
//  Copyright © 2020 Michal Ziobro. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    // MARK: - Properties
    let won: Bool
    
    // MARK: - Init
    init(size: CGSize, won: Bool) {
        self.won = won
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    override func didMove(to view: SKView) {
    
        var background: SKSpriteNode
        let sound: SKAction
        if(won) {
            background = SKSpriteNode(imageNamed: "YouWin")
            sound = SKAction.playSoundFileNamed("win.wav", waitForCompletion: false)
        } else {
            background = SKSpriteNode(imageNamed: "YouLose")
            sound = SKAction.playSoundFileNamed("lose.wav", waitForCompletion: false)
        }
        
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        
        addChild(background)
        run(sound)
        
        presentGameScene(delay: 3.0)
    }
    
    
    // MARK: - Game Loop
    override func update(_ currentTime: TimeInterval) {
    
    }
    
    private func presentGameScene(delay: TimeInterval) {
        
        let wait = SKAction.wait(forDuration: delay)
        let block = SKAction.run {
            let scene = MainMenuScene(size: self.size)
            scene.scaleMode = self.scaleMode
            let transition = SKTransition.flipHorizontal(withDuration: 0.5)
            self.view?.presentScene(scene, transition: transition)
        }
        
        run(.sequence([wait, block]))
    }
}
