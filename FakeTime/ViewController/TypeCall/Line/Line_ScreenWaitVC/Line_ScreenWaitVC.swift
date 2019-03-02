//
//  Line_ScreenWaitVC.swift
//  FakeTime
//
//  Created by Luy Nguyen on 2/12/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit
import AVKit

class Line_ScreenWaitVC: UIViewController {
    @IBOutlet weak var lbName: KHLabel!
    @IBOutlet weak var lbTime: KHLabel!
    @IBOutlet weak var lineAnimating: KHImageView!
    @IBOutlet weak var imgAvatar: KHImageView!
    @IBOutlet weak var view2Button: KHView!
    @IBOutlet weak var view1Button: KHView!
    
    var caller: CallerObj = CallerObj()
    var ringBell: AVAudioPlayer?
    var player = AVPlayer()
    var playback = Timer()
    var timer = Timer()
    var time: Int = 0 {
        didSet {
            let (m, s) = time.secondsToMinutesSeconds()
            lbTime.text = "\(m):\(s)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgAvatar.image = caller.avatar
        lbName.text = caller.name
        self.view2Button.alpha = 1
        self.view1Button.alpha = 0
        lbTime.isHidden = true
        lineAnimating.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openRingBell()
    }
    
    @IBAction func rejectCall(_ sender: Any) {
        lbTime.text = KeyString.endCall
        player.pause()
        timer.invalidate()
        playback.invalidate()
        ringBell?.stop()
        GCDCommon.mainQueueWithDelay(1) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func acceptCall(_ sender: Any) {
        lbTime.text = "00:00"
        timer.invalidate()
        ringBell?.stop()
        UIView.animate(withDuration: 0.3) {
            self.view2Button.alpha = 0
            self.view1Button.alpha = 1
            self.lbTime.isHidden = false
            self.lineAnimating.isHidden = true
        }
        turnOnAcceptCall()
    }
    
    func turnOnAcceptCall() {
        timer = Timer.every(1) {
            self.time += 1
        }
        
        var str: String = ""
        switch caller.name {
        case KeyString.gScary:
            str = KeyString.gScarySound
            break
        case KeyString.ghostClown:
            str = KeyString.ghostClownSound
            break
        case KeyString.ghostKiller:
            str = KeyString.ghostKillerSound
            break
        case KeyString.ghostScary:
            str = KeyString.ghostScarySound
            break
        case KeyString.ghost_S:
            str = KeyString.ghost_SSound
            break
        case KeyString.killerClown:
            str = KeyString.killerClownSound
            break
        default:
            str = caller.pathVideo
            break
        }
        guard str != "" else { return }
        switch caller.name {
        case KeyString.gScary, KeyString.ghostClown, KeyString.ghostKiller, KeyString.ghostScary, KeyString.ghost_S, KeyString.killerClown:
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
                            self.rejectCall(self)
                        })
                    }
                }
            }
            break
        }
    }
    
    @objc func checkCurrentTime() {
        if ringBell?.currentTime == 0 {
            rejectCall(self)
        }
    }
    
    func openRingBell() {
        lbTime.text = "Calling..."
        let path = Bundle.main.path(forResource: KeyString.soundLine, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            ringBell = try AVAudioPlayer(contentsOf: url)
            ringBell?.play()
            
            self.timer = Timer.every(1) {
                self.ringBell?.play()
            }
        } catch {
        }
    }
}

