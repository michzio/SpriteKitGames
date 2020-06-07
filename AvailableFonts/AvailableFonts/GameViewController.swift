//
//  GameViewController.swift
//  AvailableFonts
//
//  Created by Michal Ziobro on 01/06/2020.
//  Copyright © 2020 Michal Ziobro. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: CGSize(width: 2048, height: 1536))
        scene.scaleMode = .aspectFill
        
        let view = self.view as! SKView
        view.showsFPS = false
        view.showsNodeCount = false
        view.ignoresSiblingOrder = true
            
        // Present the scene
        view.presentScene(scene)
    
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
