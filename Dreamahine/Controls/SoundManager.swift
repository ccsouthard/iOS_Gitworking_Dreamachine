//
//  SoundManager.swift
//  Dreamahine
//
//  Created by mobilesupermaster on 16/02/2020.
//  Copyright © 2020 mobilesuperdeveloper. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager: NSObject {
    static let shared = SoundManager()
    var player: AVAudioPlayer?
    var volume: Float32 = 0.5 {
        didSet {
            self.player?.volume = volume
        }
    }
    func playSoundWithName(_ fileName: String, _ type: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: type) else {
            print("error")
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.volume = self.volume
            player.numberOfLoops = 2000
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playSoundWithPath(_ path: URL) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: path as URL)
            guard let player = player else { return }
            player.volume = self.volume
            player.numberOfLoops = 2000
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound() {
        if self.player != nil {
            self.player?.stop()
            self.player = nil
        }
    }
}
