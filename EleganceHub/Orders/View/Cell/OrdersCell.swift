//
//  OrdersCell.swift
//  EleganceHub
//
//  Created by raneem on 09/06/2024.
//

import UIKit

class OrdersCell: UITableViewCell {


    @IBOutlet weak var orderPriceLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellAppearance()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func setupCellAppearance() {
            
            self.contentView.layer.cornerRadius = 10
            self.contentView.layer.masksToBounds = true
            
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowOpacity = 0.5
            self.layer.shadowRadius = 4.0
            self.layer.masksToBounds = false
            
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        

        }
}
