//
//  GameScene.swift
//  AvailableFonts
//
//  Created by Michal Ziobro on 01/06/2020.
//  Copyright © 2020 Michal Ziobro. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var familyIndex = -1
    
    // MARK: - Init
    override init(size: CGSize) {
        super.init(size: size)
        showNextFamily()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    override func didMove(to view: SKView) {
        
    }
    
    // MARK: - Game Loop
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    private func showNextFamily() {
        var familyShown = false
        repeat {
            familyIndex += 1
            if familyIndex >= UIFont.familyNames.count {
                familyIndex = 0
            }
            familyShown = showCurrentFamily()
        } while !familyShown
    }
    
    private func showCurrentFamily() -> Bool {
        
        removeAllChildren()
        
        let familyName = UIFont.familyNames[familyIndex]
        
        let fontNames = UIFont.fontNames(forFamilyName: familyName)
        if fontNames.count == 0 {
            return false
        }
        
        print("Family: \(familyName)")
        
        for (idx, fontName) in fontNames.enumerated() {
            let label = SKLabelNode(fontNamed: fontName)
            label.text = fontName
            label.position = CGPoint(x: size.width/2, y: (size.height*(CGFloat(idx+1))) / (CGFloat(fontNames.count)+1) )
            label.fontSize = 50
            label.verticalAlignmentMode = .center
            addChild(label)
        }
        return true 
    }
}

// MARK: - Touch Handlers
extension GameScene {
    
    func touchDown(atPoint pos : CGPoint) {
       
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        
        showNextFamily()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
}
