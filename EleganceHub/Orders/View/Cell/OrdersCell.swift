//
//  OrdersCell.swift
//  EleganceHub
//
//  Created by raneem on 09/06/2024.
//

import UIKit

class OrdersCell: UITableViewCell {


    @IBOutlet weak var myViewContent: UIView!
    @IBOutlet weak var orderPriceLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.myViewContent.applyShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
}
