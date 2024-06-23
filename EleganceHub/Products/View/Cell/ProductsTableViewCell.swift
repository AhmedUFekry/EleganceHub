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
    
    var currencyViewModel = CurrencyViewModel()
    var rate : Double = UserDefaultsHelper.shared.getDataDoubleFound(key: UserDefaultsConstants.currencyRate.rawValue)
    let userCurrency:String = UserDefaultsHelper.shared.getCurrencyFromUserDefaults()
    var product: ProductModel!
    
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
        
        let convertedPrice = convertPrice(price: product.price ?? "2", rate: rate)
        productPrice.text = "\(String(format: "%.2f", convertedPrice)) \(userCurrency)"
        
        
        let placeholderImage = UIImage(named: "logo1")
        if let imageURl = product.properties?.first {
            productImage.kf.setImage(with: URL(string: imageURl.value ?? ""), placeholder: placeholderImage)
        }else{
            productImage.image = placeholderImage
        }
    }
}
