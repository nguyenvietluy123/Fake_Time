//
//  Messenger_ScreenWaitVC.swift
//  FakeTime
//
//  Created by Luy Nguyen on 2/11/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit
import AVKit

class Messenger_ScreenWaitVC: UIViewController {
    @IBOutlet weak var lbName: KHLabel!
    @IBOutlet weak var lbStatus: KHLabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    var caller: CallerObj = CallerObj()
    var ringBell: AVAudioPlayer?
    var timer = Timer()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GCDCommon.mainQueueWithDelay(1) {
            self.lbStatus.text = "Đang đổ chuông..."
            self.openRingBell()
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

extension Messenger_ScreenWaitVC {
    func initUI() {
        lbName.text = caller.name
        imgAvatar.image = caller.avatar
    }
    
    func openRingBell() {
        let path = Bundle.main.path(forResource: "call_messenger.m4a", ofType:nil)!
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
        
//        let videoCallView = VideoCallView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//        self.view.addSubview(videoCallView)
//
//        UIView.animate(withDuration: 0.3, animations: {
//            videoCallView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        }) { (completed) in
//            videoCallView.showVideo(caller: self.caller)
//        }
//
//        videoCallView.handleEndCall = {
//            self.dismiss(animated: true, completion: nil)
//            UIView.animate(withDuration: 0.3, animations: {
//                videoCallView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//            }) { (completed) in
//                videoCallView.removeFromSuperview()
//            }
//        }
    }
}
