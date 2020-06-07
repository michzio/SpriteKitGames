//
//  BackgroundMusic.swift
//  ZombieConga
//
//  Created by Michal Ziobro on 31/05/2020.
//  Copyright © 2020 Michal Ziobro. All rights reserved.
//

import Foundation
import AVFoundation

class BackgroundMusic {
    
    private static var player: AVAudioPlayer!
    
    public static func play(filename: String) {
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("Could not find file: \(filename)")
            return
        }
        
        do {
            try player = AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            player.prepareToPlay()
            player.play()
            
        } catch {
            print("Could not create audio player!")
            return
        }
    }
    
    public static func stop() {
        player?.stop()
    }
}
