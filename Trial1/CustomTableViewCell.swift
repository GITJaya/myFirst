//
//  CustomTableViewCell.swift
//  Trial1
//
//  Created by Jaya   on 09/03/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var artWorkImgView: UIImageView!

    
    @IBOutlet weak var artistLabel: UILabel!
    
    
    @IBOutlet weak var trackLabel: UILabel!
    
    
    @IBOutlet weak var collectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
