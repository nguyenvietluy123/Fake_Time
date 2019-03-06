//
//  CellListCall.swift
//  FakeTime
//
//  Created by Luy Nguyen on 1/24/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit

class CellListCall: UITableViewCell {
    @IBOutlet weak var imgAvatar: KHImageView!
    @IBOutlet weak var lbName: KHLabel!
    @IBOutlet weak var viewEdit: KHView!
    
    var handleEdit: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionEdit(_ sender: Any) {
        handleEdit?()
    }
}

extension CellListCall {
    func config(caller: CallerObj) {
        self.imgAvatar.image = caller.avatar
        self.lbName.text = caller.name
        viewEdit.isHidden = caller.name == KeyString.santaClaus || caller.name == KeyString.noel || caller.name == KeyString.santa
    }
}
