//
//  CallView.swift
//  FakeTime
//
//  Created by Luy Nguyen on 1/30/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit

class CallView: UIView {
    @IBOutlet weak var lbNumber: KHLabel!
    @IBOutlet weak var lbTime: KHLabel!
    
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
        let xibFileName = "CallView" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        startTime()
    }
    
    func startTime() {
        timer = Timer.every(1, {
            self.time += 1
        })
    }
    
    @IBAction func actionEndCall(_ sender: Any) {
        lbTime.text = KeyString.endCall
        timer.invalidate()
        GCDCommon.mainQueueWithDelay(1, {
            self.handleEndCall?()
        })
    }
}
