//
//  SearchProductCell.swift
//  EleganceHub
//
//  Created by Shimaa on 01/06/2024.
//

import UIKit
import Kingfisher

class SearchProductCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchProductImageView: UIImageView!
    @IBOutlet weak var searchProductTxt: UILabel!
    @IBOutlet weak var searchProductPriceTxt: UILabel!
    //@IBOutlet weak var searchProductRating: UILabel!
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
        
        
        setupConstraints()
        setupAppearance()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setProductToTableCell(product: ProductModel) {
        self.product = product
                
                if let imageUrlString = product.image?.src, let imageUrl = URL(string: imageUrlString) {
                    searchProductImageView.kf.setImage(with: imageUrl)
                } else {
                    searchProductImageView.image = nil
                }
                
                searchProductTxt.text = Utilities.splitName(text: product.title ?? "No Title", delimiter: " | ")
        
                guard let rate = self.rate else {
                    searchProductPriceTxt.text = "550.4"
                    return
                }
                
                let convertedPrice = convertPrice(price: product.variants?.first?.price ?? "2", rate: rate)
                searchProductPriceTxt.text = "\(String(format: "%.2f", convertedPrice)) \(userCurrency)"
            
            }
    
    private func setupConstraints() {
            searchProductImageView.translatesAutoresizingMaskIntoConstraints = false
            searchProductTxt.translatesAutoresizingMaskIntoConstraints = false
            searchProductPriceTxt.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                searchProductImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
                searchProductImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
                searchProductImageView.widthAnchor.constraint(equalToConstant: 80),
                searchProductImageView.heightAnchor.constraint(equalToConstant: 80),
                
                searchProductTxt.leadingAnchor.constraint(equalTo: searchProductImageView.trailingAnchor, constant: 10),
                searchProductTxt.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
                searchProductTxt.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
                
                searchProductPriceTxt.leadingAnchor.constraint(equalTo: searchProductImageView.trailingAnchor, constant: 10),
                searchProductPriceTxt.topAnchor.constraint(equalTo: searchProductTxt.bottomAnchor, constant: 5),
                searchProductPriceTxt.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10)
            ])
        }
        
        private func setupAppearance() {
            containerView.layer.cornerRadius = 20
            containerView.layer.masksToBounds = true
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.white.cgColor
                    
            self.contentView.layer.cornerRadius = 20
            self.contentView.layer.masksToBounds = true
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowOpacity = 0.2
            self.layer.shadowRadius = 2
        }
    }
