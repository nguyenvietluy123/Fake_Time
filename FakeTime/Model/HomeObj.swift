//
//  CallObj.swift
//  FakeTime
//
//  Created by Luy Nguyen on 1/24/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit

class HomeObj: NSObject {
    var img: UIImage
    var title: String
    var isSelected: Bool = false
    var typeCall: typeCall = .call
    
    init(_ img: UIImage, title: String, typeCall: typeCall, isSelected: Bool = false) {
        self.img = img
        self.title = title
        self.isSelected = isSelected
        self.typeCall = typeCall
    }
}
