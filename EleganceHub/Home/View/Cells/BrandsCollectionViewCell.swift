//
//  BrandsCollectionViewCell.swift
//  EleganceHub
//
//  Created by raneem on 23/05/2024.
//

import UIKit


class BrandsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var brandImage: UIImageView!
    @IBOutlet weak var brandName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        brandImage.layer.borderWidth = 2.0
        brandImage.layer.cornerRadius = 10.0
        brandImage.clipsToBounds = true
        brandImage.layer.borderColor = UIColor.secondaryLabel.cgColor//UIColor(named: "btnColor")?.cgColor ?? UIColor.black.cgColor
    }
}

