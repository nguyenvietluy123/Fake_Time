//
//  MenuObj.swift
//  Carenefit
//
//  Created by Hoa Phan on 9/14/17.
//  Copyright © 2017 sdc. All rights reserved.
//

import UIKit

class NavigationView: UIView {
    @IBOutlet weak var ctrHeightStatusBar: NSLayoutConstraint!
    @IBOutlet weak var imvShowMenu: UIImageView!
    @IBOutlet weak var ctrHeightImageShowMenu: NSLayoutConstraint!
    @IBOutlet weak var lbTitleNav: KHLabel!
    @IBOutlet weak var viewRight: UIView!
    @IBOutlet weak var imgActionRight: UIImageView!
    @IBOutlet weak var viewLeft: UIView!
    @IBOutlet weak var imvBackgoundNavi: UIImageView!
    
    @IBInspectable open var title: String = "" {
        didSet {
            lbTitleNav.text = title.localized
        }
    }
    
    @IBInspectable open var hasLeft: Bool = true {
        didSet {
            viewLeft.isHidden = !hasLeft
        }
    }
    
    @IBInspectable open var hasRight: Bool = false {
        didSet {
            imgActionRight.image = #imageLiteral(resourceName: "navi_pen")
            viewRight.isHidden = !hasRight
        }
    }
    
    @IBInspectable open var rightToSave: Bool = false {
        didSet {
            imgActionRight.image = rightToSave ? #imageLiteral(resourceName: "ListCall_save") : #imageLiteral(resourceName: "navi_pen")
        }
    }
    
    @IBInspectable open var hasBack: Bool = false {
        didSet {
            if hasBack {
                imvShowMenu.image = #imageLiteral(resourceName: "navi_back")
            }
        }
    }
    
    @IBAction func actionRight(_ sender: Any) {
        handleActionRight?()
    }
    
    var handleBack: (() -> Void)?
    var handleMenu: (() -> Void)?
    var handleActionRight: (() -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "NavigationView" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for ctr in self.constraints {
            if ctr.firstAttribute == .height {
                if DeviceType.IS_IPAD {
                    ctr.constant = 85
                } else if DeviceType.IS_IPHONE_X {
                    ctr.constant = 49 + UIApplication.shared.statusBarFrame.height
                } else {
                    ctr.constant = 69*ScreenSize.SCREEN_HEIGHT/736
                }
            }
        }
        ctrHeightStatusBar.constant = UIApplication.shared.statusBarFrame.height
        GCDCommon.mainQueue {
            Common.gradient(UIColor.init("61eda2", alpha: 1.0), UIColor.init("22cfa4", alpha: 1.0), view: self)
        }
    }
  
    @IBAction func actionHome(_ sender: Any) {
        if hasBack {
            handleBack?()
        }else {
            handleMenu?()
        }
    }

}
