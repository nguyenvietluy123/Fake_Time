//
//  CellCollectionHome.swift
//  FakeTime
//
//  Created by Luy Nguyen on 3/2/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit

class CellCollectionHome: UICollectionViewCell {
    @IBOutlet weak var img: KHImageView!
    @IBOutlet weak var viewIsSelected: KHView!
    @IBOutlet weak var viewNotSelected: KHView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension CellCollectionHome {
    func config(_ homeObj: HomeObj) {
        self.img.image = homeObj.img
        
        viewIsSelected.isHidden = !homeObj.isSelected
        viewNotSelected.isHidden = homeObj.isSelected
        
    }
}
