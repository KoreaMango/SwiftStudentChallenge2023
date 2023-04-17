//
//  SoundManager.swift
//  SwiftStudentChallenge2023
//
//  Created by 강민규 on 2023/04/17.
//

import Foundation
import AVFoundation
import UIKit

class SoundManager {
    var soundPlayer = AVAudioPlayer()
    
    func playThrowSound() {
        let path = Bundle.main.path(forResource: "throwSound.mp3", ofType:nil)!

        let url = URL(fileURLWithPath: path)

        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()) {
                self.soundPlayer.play()
            }
        } catch {
            // couldn't load file :(
        }
    }
}
