//
//  CellHome.swift
//  FakeTime
//
//  Created by Luy Nguyen on 1/24/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit

class CellHome: UITableViewCell {
    @IBOutlet weak var title: KHLabel!
    @IBOutlet weak var img: KHImageView!
    @IBOutlet weak var viewIsSelected: KHView!
    @IBOutlet weak var viewNotSelected: KHView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CellHome {
    func config(_ homeObj: HomeObj) {
        self.title.text = homeObj.title
        self.img.image = homeObj.img
        
        viewIsSelected.isHidden = !homeObj.isSelected
        viewNotSelected.isHidden = homeObj.isSelected
        
    }
}
