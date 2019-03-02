//
//  WechatVideoCallView.swift
//  FakeTime
//
//  Created by Luy Nguyen on 2/12/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit
import AVKit

class WechatVideoCallView: UIView {
    @IBOutlet weak var viewShowVideo: KHView!
    @IBOutlet weak var lbTime: KHLabel!
    
    var player = AVPlayer()
    var handleEndCall:(() -> ())?
    var timer = Timer()
    var time: Int = 0 {
        didSet {
            let (m, s) = time.secondsToMinutesSeconds()
            lbTime.text = "\(m):\(s)"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "WechatVideoCallView" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func showVideo(caller: CallerObj) {
        timer = Timer.every(1) {
            self.time += 1
        }
        
        var str = ""
        if caller.name == KeyString.gScary || caller.name == KeyString.ghostClown || caller.name == KeyString.ghostKiller || caller.name == KeyString.ghostScary || caller.name == KeyString.ghost_S || caller.name == KeyString.killerClown {
            str = Bundle.main.path(forResource: caller.pathVideo, ofType: nil) ?? ""
        } else {
            str = caller.pathVideo
        }
        
        player = AVPlayer(url: URL(fileURLWithPath: str))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.viewShowVideo.bounds
        self.viewShowVideo.layer.addSublayer(playerLayer)
        player.play()
        
        let intervalTime = CMTime(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: intervalTime, queue: DispatchQueue.main) { (progressTime) in
            let second = CMTimeGetSeconds(progressTime)
            if let duration = self.player.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                
                if second == durationSeconds {
                    self.timer.invalidate()
                    self.lbTime.text = KeyString.endCall
                    GCDCommon.mainQueueWithDelay(1, {
                        self.handleEndCall?()
                    })
                }
            }
        }
    }
    
    @IBAction func actionEndCall(_ sender: Any) {
        lbTime.text = KeyString.endCall
        self.player.pause()
        timer.invalidate()
        GCDCommon.mainQueueWithDelay(1, {
            self.handleEndCall?()
        })
    }
}
