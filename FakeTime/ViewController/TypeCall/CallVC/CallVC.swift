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
    @IBOutlet weak var viewFontCamera: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
}

extension CallVC {
    func initUI() {
        var defaultVideoDevice: AVCaptureDevice?
        if let fontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            defaultVideoDevice = fontCameraDevice
        }
        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: defaultVideoDevice!)
//            vide
        } catch {
            print("Can't access camera")
        }
        
    }
}
