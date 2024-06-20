//
//  CouponsCollectionViewCell.swift
//  EleganceHub
//
//  Created by raneem on 23/05/2024.
//

import UIKit

class CouponsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var couponsLabel: UILabel!
    @IBOutlet weak var couponsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.borderWidth = 2.0
        contentView.layer.cornerRadius = 10.0
        contentView.clipsToBounds = true
        contentView.layer.borderColor = UIColor.black.cgColor
    }
}
