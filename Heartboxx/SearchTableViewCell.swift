//
//  SearchTableViewCell.swift
//  Heartboxx
//
//  Created by dev on 5/10/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//



import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet var imgHistory: UIImageView!
    
    
    @IBOutlet var lblShopName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
