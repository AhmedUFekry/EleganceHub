//
//  PaymentMethodTableViewCell.swift
//  EleganceHub
//
//  Created by AYA on 25/05/2024.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {

    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var paymentMethodImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        paymentMethodImage.layer.cornerRadius = 25
        self.contentView.layer.cornerRadius = 15
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
