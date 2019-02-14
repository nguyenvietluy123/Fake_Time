//
//  Privacy_PolicyVC.swift
//  FakeWeather
//
//  Created by Luy Nguyen on 1/21/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit

class Privacy_PolicyVC: BaseVC {
    @IBOutlet weak var navi: NavigationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navi.handleMenu = {
            self.clickMenu()
        }
    }
}
