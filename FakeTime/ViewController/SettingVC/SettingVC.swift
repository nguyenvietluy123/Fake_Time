//
//  SettingVC.swift
//  FakeTime
//
//  Created by Luy Nguyen on 1/27/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit

class SettingVC: BaseVC {
    @IBOutlet weak var navi: NavigationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
}

extension SettingVC {
    func initUI() {
        navi.handleMenu = {
            self.clickMenu()
        }
    }
    
}
