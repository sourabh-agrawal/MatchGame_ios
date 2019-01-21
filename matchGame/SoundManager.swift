//
//  SoundManager.swift
//  matchGame
//
//  Created by sourabh agrawal on 21/01/19.
//  Copyright © 2019 sourabh. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager{
    
    // make property and method static so we can call them using class name
    static var audioPlayer:AVAudioPlayer?
    
    enum soundEffect{
        case flip
        case shuffle
        case match
        case nomatch
    }
    
    static func playSound(_ effect : soundEffect){
        
        var soundFileName = ""
        
        //determine which sound effect we want to play
        // set the file name to the variable
        
        switch effect {
        case .flip:
            soundFileName = "cardflip"
        case .match:
            soundFileName = "dingcorrect"
        case .nomatch:
            soundFileName = "dingwrong"
        case .shuffle:
            soundFileName = "shuffle"
        
        }
        
        //get the path of the sound file inside the bundle
        let soundPath = Bundle.main.path(forResource: soundFileName, ofType: "wav")
        
        guard soundPath != nil else{
            print("could not find sound file \(soundFileName) inside the bundle")
            return
        }
        
        // create url object from sound path
        let soundURL = URL(fileURLWithPath: soundPath!)
        
        do{
            // create audio player object
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            // Play the sound
            audioPlayer?.play()
        }
        catch{
            // couldn't create audioPlayer object so log the error
            print("couldn't create audioPlayer object for the sound file \(soundFileName)")
        }
        
    }
}
