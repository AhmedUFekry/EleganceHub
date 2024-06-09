//
//  CartTableViewCell.swift
//  EleganceHub
//
//  Created by AYA on 25/05/2024.
//

import UIKit
import Kingfisher

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var decreaseQuantityBtn: UIButton!
    @IBOutlet weak var IncreaseQuantityBtn: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productVarintLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        productImage.layer.cornerRadius = 10
        setupShadow()
        productNameLabel.adjustsFontSizeToFitWidth = true // bool
        productNameLabel.minimumScaleFactor = 0.5
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupShadow() {
        viewContainer.layer.shadowColor = UIColor.black.cgColor
        viewContainer.layer.shadowOpacity = 0.5
        viewContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewContainer.layer.shadowRadius = 4
        viewContainer.layer.cornerRadius = 10
        //personUIView.layer.shadowPath = UIBezierPath(roundedRect: self.personUIView.bounds, cornerRadius: self.personUIView.layer.cornerRadius).cgPath
    }
    
    func setCellData(order:LineItem){
        productNameLabel.text = order.title
        productPriceLabel.text = order.price
        productVarintLabel.text = order.vendor
        productQuantityLabel.text = "1"
        //properties?.first is the image
        let placeholderImage = UIImage(named: "AppIcon")
        if let imageURl = order.properties?.first?.value {
            productImage.kf.setImage(with: URL(string: imageURl), placeholder: placeholderImage)
        }else{
            productImage.image = placeholderImage
        }
        
    }
    
    //func setContent
    
}
