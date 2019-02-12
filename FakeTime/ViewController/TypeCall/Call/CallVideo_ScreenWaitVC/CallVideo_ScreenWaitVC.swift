//
//  CallVC.swift
//  FakeTime
//
//  Created by Luy Nguyen on 1/27/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit
import AVKit

class CallVideo_ScreenWaitVC: UIViewController {
    @IBOutlet weak var lbName: KHLabel!
    @IBOutlet weak var lbPhoneNumber: KHLabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var viewTop: KHView!
    
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
        GCDCommon.mainQueue {
            Common.gradient(UIColor.init("61eda2", alpha: 1.0), UIColor.init("22cfa4", alpha: 1.0), view: self.viewTop)
        }
    }
    
    @IBAction func actionReject(_ sender: Any) {
        timer.invalidate()
        ringBell?.stop()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionAccept(_ sender: Any) {
        acceptCallVideo()
    }
}

extension CallVideo_ScreenWaitVC {
    func initUI() {
        lbName.text = caller.name
        lbPhoneNumber.text = caller.phoneNumber
        imgAvatar.image = caller.avatar
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
        
        let videoCallView = VideoCallView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
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
