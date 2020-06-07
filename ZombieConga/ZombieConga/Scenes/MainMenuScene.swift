//
//  MainMenuScene.swift
//  ZombieConga
//
//  Created by Michal Ziobro on 31/05/2020.
//  Copyright © 2020 Michal Ziobro. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "MainMenu")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        
        addChild(background)
    }
}

// MARK: - Touch Handlers
extension MainMenuScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        presentGameScene()
    }
}

extension MainMenuScene {
    
    private func presentGameScene() {
        
        let scene = GameScene(size: size)
        scene.scaleMode = scaleMode
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 1.5)
            
        view?.presentScene(scene, transition: transition)
    }
}
