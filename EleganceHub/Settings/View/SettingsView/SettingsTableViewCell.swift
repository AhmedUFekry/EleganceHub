//
//  SettingsTableViewCell.swift
//  EleganceHub
//
//  Created by AYA on 01/06/2024.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellIcon : UIImageView!
    @IBOutlet weak var cellLable :UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
