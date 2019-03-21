//
//  CallerHelper.swift
//  FakeTime
//
//  Created by Luy Nguyen on 3/9/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit
import AVKit

class CallerHelper: NSObject {
    static let shared = CallerHelper()
    
    var handleCountTime: ((String) -> ())?
    var handleDismiss: (() -> ())?
    var player = AVPlayer()
    var ringBell: AVAudioPlayer?
    var playback = Timer()
    var timer = Timer()
    var time: Int = 0 {
        didSet {
            let (m, s) = time.secondsToMinutesSeconds()
            handleCountTime?("\(m):\(s)")
        }
    }
    
    func turnOnAcceptCall(caller: CallerObj) {
        time = 0
        timer = Timer.every(1) {
            self.time += 1
        }
        
        var str: String = ""
        switch caller.name {
        case KeyString.santaClaus:
            str = KeyString.santaClausSound
            break
        case KeyString.noel:
            str = KeyString.noelSound
            break
        case KeyString.santa:
            str = KeyString.santaSound
            break
        default:
            str = caller.pathVideo
            break
        }
        guard str != "" else { return }
        
        switch caller.name {
        case KeyString.santaClaus, KeyString.noel, KeyString.santa:
            //run file from bundle
            if let path = Bundle.main.path(forResource: str, ofType: nil) {
                let url = URL(fileURLWithPath: path)
                do {
                    ringBell = try AVAudioPlayer(contentsOf: url)
                    ringBell?.play()
                    playback = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(checkCurrentTime), userInfo: nil, repeats: true)
                    
                } catch {
                }
            }
            break
        default:
            //run sound without display video
            player = AVPlayer(url: URL(fileURLWithPath: str))
            player.play()
            
            let intervalTime = CMTime(value: 1, timescale: 2)
            player.addPeriodicTimeObserver(forInterval: intervalTime, queue: DispatchQueue.main) { (progressTime) in
                let second = CMTimeGetSeconds(progressTime)
                if let duration = self.player.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    
                    if second == durationSeconds {
                        GCDCommon.mainQueueWithDelay(1, {
                            self.rejectCall()
                        })
                    }
                }
            }
            break
        }
    }
    
    @objc func checkCurrentTime() {
        if ringBell?.currentTime == 0 {
            rejectCall()
        }
    }
    
    func rejectCall() {
        handleCountTime?(KeyString.endCall)
        player.pause()
        timer.invalidate()
        playback.invalidate()
        ringBell?.stop()
        GCDCommon.mainQueueWithDelay(1) {
            self.handleDismiss?()
        }
    }
}

let callerShared = CallerHelper.shared
