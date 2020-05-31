//
//  GameViewController.swift
//  ZombieConga
//
//  Created by Michal Ziobro on 24/05/2020.
//  Copyright © 2020 Michal Ziobro. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as? SKView else { return }
        
        let scene = GameScene(size: CGSize(width: 2048, height: 1536))
        scene.scaleMode = .aspectFill
        view.presentScene(scene)
            
            
        view.showsFPS = true
        view.showsNodeCount = true
        view.ignoresSiblingOrder = true
        
       
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
