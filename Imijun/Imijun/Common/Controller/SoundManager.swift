//
//  SoundManager.swift
//  Imijun
//
//  Created by Khoa Vu on 10/24/16.
//  Copyright © 2016 ARIS-VN. All rights reserved.
//

import UIKit
import AVFoundation


@objc protocol AIMSoundManagerDelgate: NSObjectProtocol{
    func audioPlayerDidFinishPlaying()
}

class SoundManager: NSObject ,AVAudioRecorderDelegate,AVAudioPlayerDelegate{

    var audioPlayer:AVAudioPlayer?
    weak var delegate: AIMSoundManagerDelgate?
    
    func playAudio(path:String?) {
        if path != nil {
            //            if self.audioPlayer?.playing == true {
            //                self.stop()
            //
            //            }
                        
            let url = NSURL.fileURL(withPath: path!)
            
            if self.audioPlayer != nil {
                self.stop()
            }
            do{
                self.audioPlayer = try AVAudioPlayer.init(contentsOf: url)
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
            } catch {
                return;
            }
            
            self.audioPlayer?.play()
        }
    }
    
    
    func stop() {
        
        if self.audioPlayer !=  nil {
            self.audioPlayer?.stop()
            self.audioPlayer = nil
        }
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.delegate?.audioPlayerDidFinishPlaying()
    }
}

