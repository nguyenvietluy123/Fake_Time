//
//  LineVideo_ScreenWaitVC.swift
//  FakeTime
//
//  Created by Luy Nguyen on 2/12/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit
import AVKit

class LineVideo_ScreenWaitVC: UIViewController {
    @IBOutlet weak var lbName: KHLabel!
    @IBOutlet weak var lbAnimating: KHLabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    
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
    
    @IBAction func actionReject(_ sender: Any) {
        lbAnimating.text = KeyString.endCall
        timer.invalidate()
        ringBell?.stop()
        GCDCommon.mainQueueWithDelay(1) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func actionAccept(_ sender: Any) {
        acceptCallVideo()
    }
}

extension LineVideo_ScreenWaitVC {
    func initUI() {
        lbName.text = caller.name
        imgAvatar.image = caller.avatar
    }
    
    func openRingBell() {
        let path = Bundle.main.path(forResource: KeyString.soundLine, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            ringBell = try AVAudioPlayer(contentsOf: url)
            ringBell?.play()
            
            timer = Timer.every(1) {
                self.ringBell?.play()
            }
        } catch {
        }
    }
    
    func acceptCallVideo() {
        timer.invalidate()
        ringBell?.stop()
        
        let videoCallView = LineVideoCallView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.view.addSubview(videoCallView)
        
        UIView.animate(withDuration: 0.3, animations: {
            videoCallView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }) { (completed) in
            videoCallView.showVideo(caller: self.caller)
        }
        
        videoCallView.handleEndCall = {
            self.dismiss(animated: true, completion: nil)
            UIView.animate(withDuration: 0.3, animations: {
                videoCallView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }) { (completed) in
                videoCallView.removeFromSuperview()
            }
        }
    }
}
