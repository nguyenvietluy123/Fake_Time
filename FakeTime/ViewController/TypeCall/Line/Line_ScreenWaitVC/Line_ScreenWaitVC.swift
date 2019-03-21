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
        
        callerShared.handleCountTime = { str in
            self.lbTime.text = str
        }
        callerShared.handleDismiss = {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openRingBell()
    }
    
    @IBAction func rejectCall(_ sender: Any) {
        timer.invalidate()
        ringBell?.stop()
        callerShared.rejectCall()
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
        callerShared.turnOnAcceptCall(caller: caller)
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

