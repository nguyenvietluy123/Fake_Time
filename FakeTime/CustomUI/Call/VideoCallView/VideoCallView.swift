//
//  VideoCallView.swift
//  FakeTime
//
//  Created by Luy Nguyen on 1/30/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit
import AVKit

class VideoCallView: UIView {
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
        let xibFileName = "VideoCallView" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func showVideo(caller: CallerObj) {
        
        player = AVPlayer(url: URL(fileURLWithPath: caller.pathVideo))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.viewShowVideo.bounds
        self.viewShowVideo.layer.addSublayer(playerLayer)
        player.play()
        
        let intervalTime = CMTime(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: intervalTime, queue: DispatchQueue.main) { (progressTime) in
            let second = CMTimeGetSeconds(progressTime)
            if let duration = self.player.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                print(durationSeconds)
                
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
