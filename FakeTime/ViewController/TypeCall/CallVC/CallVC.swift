//
//  CallVC.swift
//  FakeTime
//
//  Created by Luy Nguyen on 1/27/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit
import AVKit

class CallVC: UIViewController {
    @IBOutlet weak var frontCameraView: FrontCameraView!
    @IBOutlet weak var lbName: KHLabel!
    @IBOutlet weak var lbPhoneNumber: KHLabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var viewTop: KHView!
    @IBOutlet weak var viewAfterAccept: KHView!
    @IBOutlet weak var viewShowVideo: KHView!
    
    var caller: CallerObj = CallerObj()
    var ringBell: AVAudioPlayer?
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openRingBell()
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    @IBAction func actionReject(_ sender: Any) {
        timer.invalidate()
        ringBell?.stop()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionAccept(_ sender: Any) {
        acceptCallVideo()
    }
    
    @IBAction func actionEndCall(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CallVC {
    func initUI() {
        lbName.text = caller.name
        lbPhoneNumber.text = caller.phoneNumber
        imgAvatar.image = caller.avatar
        
//        viewAfterAccept.clearConstraints()
        viewAfterAccept.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        viewAfterAccept.updateConstraints()
        
        GCDCommon.mainQueue {
            Common.gradient(UIColor.init("61eda2", alpha: 1.0), UIColor.init("22cfa4", alpha: 1.0), view: self.viewTop)
        }
    }
    
    func openRingBell() {
        let path = Bundle.main.path(forResource: "call_line.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            ringBell = try AVAudioPlayer(contentsOf: url)
            ringBell?.play()
            
            timer = Timer.every(1) {
                print(TimeInterval.init(exactly: (self.ringBell?.duration)!)!)
                self.ringBell?.play()
            }
        } catch {
        }
    }
    
    func acceptCallVideo() {
        timer.invalidate()
        ringBell?.stop()
        
        GCDCommon.mainQueue {
            self.viewAfterAccept.layoutIfNeeded()
            UIView.animate(withDuration: 1.2, delay: 0, options: .curveEaseOut, animations: {
//                self.viewAfterAccept.isHidden = false
                self.view.layoutIfNeeded()
                self.viewAfterAccept.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }, completion: { (completed) in
                var player = AVPlayer()
                player = AVPlayer(url: URL(fileURLWithPath: self.caller.pathVideo))
                let playerLayer = AVPlayerLayer(player: player)
                playerLayer.frame = self.viewShowVideo.bounds
                self.viewShowVideo.layer.addSublayer(playerLayer)
                player.play()
            })
        }
    }
}

extension UIView {
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
}
