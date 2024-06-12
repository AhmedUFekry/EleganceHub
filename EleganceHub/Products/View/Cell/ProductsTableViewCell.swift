//
//  ProductsTableViewCell.swift
//  EleganceHub
//
//  Created by raneem on 24/05/2024.
//

import UIKit

class ProductsTableViewCell: UITableViewCell {
    @IBOutlet weak var backGroundview: UIView!
    
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var ProductTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     self.backGroundview.applyShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
