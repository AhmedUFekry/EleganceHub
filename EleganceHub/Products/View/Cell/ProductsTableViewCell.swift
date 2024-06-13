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

    }
    func setCellUI(product: LineItem) {
        
            ProductTitle?.text = product.title
            productCategory?.text = "Quantity: \(String(describing: product.quantity ?? 2))"
            productPrice?.text = product.price
            
            let placeholderImage = UIImage(named: "adidas")
            if let imageURl = product.properties?.first {
                productImage.kf.setImage(with: URL(string: imageURl.value ?? ""), placeholder: placeholderImage)
            }else{
                productImage.image = placeholderImage
            }
            
        

        }
}
