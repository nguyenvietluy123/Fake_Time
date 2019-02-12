//
//  MessengerVideo_ScreenWaitVC.swift
//  FakeTime
//
//  Created by Luy Nguyen on 2/11/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit
import AVKit

class MessengerVideo_ScreenWaitVC: UIViewController {
    @IBOutlet weak var lbName: KHLabel!
    @IBOutlet weak var lbPhoneNumber: KHLabel!
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
        timer.invalidate()
        ringBell?.stop()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionAccept(_ sender: Any) {
        acceptCallVideo()
    }
}

extension MessengerVideo_ScreenWaitVC {
    func initUI() {
        lbName.text = caller.name
        lbPhoneNumber.text = caller.phoneNumber
        imgAvatar.image = caller.avatar
    }
    
    func openRingBell() {
        let path = Bundle.main.path(forResource: "call_messenger.m4a", ofType:nil)!
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
        
        let videoView = MsgVideoCallView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.view.addSubview(videoView)
        
        UIView.animate(withDuration: 0.3, animations: {
            videoView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }) { (completed) in
            videoView.showVideo(caller: self.caller)
        }
        
        videoView.handleEndCall = {
            self.dismiss(animated: true, completion: nil)
            UIView.animate(withDuration: 0.3, animations: {
                videoView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }) { (completed) in
                videoView.removeFromSuperview()
            }
        }
    }
}
