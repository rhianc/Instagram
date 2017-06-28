//
//  UIInstagramTableViewCell.swift
//  rhians-instagram
//
//  Created by Rhian Chavez on 6/28/17.
//  Copyright © 2017 Rhian Chavez. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UIInstagramTableViewCell: UITableViewCell {

    @IBOutlet weak var picture: PFImageView!
    @IBOutlet weak var caption: UILabel!
    var label: String?
    var specifc: PFFile?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        caption.text = label!
//        picture.file = specifc!
//        picture.loadInBackground()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
