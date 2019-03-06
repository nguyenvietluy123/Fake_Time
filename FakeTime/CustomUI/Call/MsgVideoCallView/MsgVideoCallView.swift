//
//  MsgVideoCallView.swift
//  FakeTime
//
//  Created by Luy Nguyen on 2/11/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit
import AVKit

class MsgVideoCallView: UIView {
    @IBOutlet weak var viewShowVideo: KHView!
    
    var player = AVPlayer()
    var handleEndCall:(() -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "MsgVideoCallView" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func showVideo(caller: CallerObj) {
        var str = ""
        if caller.name == KeyString.santaClaus || caller.name == KeyString.noel || caller.name == KeyString.santa {
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
                    GCDCommon.mainQueueWithDelay(1, {
                        self.handleEndCall?()
                    })
                }
            }
        }
    }
    
    @IBAction func actionEndCall(_ sender: Any) {
        self.player.pause()
        GCDCommon.mainQueueWithDelay(1, {
            self.handleEndCall?()
        })
    }
}
