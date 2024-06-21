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
    var rate : Double?
    let userCurrency = UserDefaultsHelper.shared.getCurrencyFromUserDefaults().uppercased()
    var product: ProductModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        currencyViewModel.rateClosure = {
            [weak self] rate in
            DispatchQueue.main.async {
                self?.rate = rate
            }
        }
        currencyViewModel.getRate()
        
        self.backGroundview.applyShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setCellUI(product: LineItem) {
        
        ProductTitle?.text = product.title
        productCategory?.text = "Quantity: \(String(describing: product.quantity ?? 2))"
        
        guard let rate = self.rate else {
            productPrice.text = "1543 EGP"
            return
        }
        
        let convertedPrice = convertPrice(price: product.price ?? "2", rate: rate)
        productPrice.text = "\(String(format: "%.2f", convertedPrice)) \(userCurrency)"
        
        
        // productPrice?.text = product.price
        
        let placeholderImage = UIImage(named: "adidas")
        if let imageURl = product.properties?.first {
            productImage.kf.setImage(with: URL(string: imageURl.value ?? ""), placeholder: placeholderImage)
        }else{
            productImage.image = placeholderImage
        }
    }
}
