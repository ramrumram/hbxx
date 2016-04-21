//
//  HistoryTableViewCell.swift
//  Heartboxx
//
//  Created by dev on 4/21/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet var imgHistory: UIView!
    
    @IBOutlet var lblShopName: UILabel!
    
    @IBOutlet var lblCategory: UILabel!
    
    @IBOutlet var btnSuggestion: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
