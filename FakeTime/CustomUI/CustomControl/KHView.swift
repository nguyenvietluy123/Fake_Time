//
//  KHView.swift
//  Design
//
//  Created by Hoa on 6/21/17.
//  Copyright © 2017 SDC. All rights reserved.
//

import UIKit

//@IBDesignable
class KHView: UIView {
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var isGradientColor: Bool = false {
        didSet {
            
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = isIPad ? 1.4*borderWidth : borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius * heightRatio
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var shadow: Bool = false {
        didSet {
            if shadow {
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOffset = CGSize.zero
                layer.shadowOpacity = 0.1
                layer.shadowRadius = 4.0
                layer.masksToBounds = false
            }
        }
    }
    
    @IBInspectable var circle: Bool = false {
        didSet {
            if circle {
                layer.cornerRadius = self.bounds.height/2
                layer.masksToBounds = true
            }
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        if circle {
            layer.cornerRadius = self.bounds.height/2
            layer.masksToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if circle {
            layer.cornerRadius = self.bounds.height/2
            layer.masksToBounds = true
        }
        if isGradientColor {
            GCDCommon.mainQueue {
                Common.gradient(UIColor.init("61eda2", alpha: 1.0), UIColor.init("22cfa4", alpha: 1.0), view: self)
            }
        }
    }
}
