//
//  Privacy_PolicyVC.swift
//  FakeWeather
//
//  Created by Luy Nguyen on 1/21/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit
import GoogleMobileAds

class Privacy_PolicyVC: BaseVC {
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAdmob()
        
        navi.handleMenu = {
            self.clickMenu()
        }
    }
    
    func initAdmob() {
        bannerView.adUnitID = kAdmobBanner
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
        
    }
}

extension Privacy_PolicyVC: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
}
