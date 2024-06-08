//
//  CategoryCollectionViewCell.swift
//  EleganceHub
//
//  Created by raneem on 01/06/2024.
//

import UIKit

@IBDesignable
class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryPrice: UILabel!
    @IBOutlet weak var categoryType: UILabel!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryImage.layer.borderWidth = 2.0
        categoryImage.layer.cornerRadius = 10.0
        categoryImage.clipsToBounds = true
        categoryImage.layer.borderColor = UIColor.black.cgColor
        
    }
}
