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
    
    var product: ProductModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
                
                if let priceString = product.variants?.first?.price, let price = Double(priceString) {
                    searchProductPriceTxt.text = String(format: "$%.2f", price)
                } else {
                    searchProductPriceTxt.text = "No Price"
                }
                
//                searchProductRating.text = Utilities.formatRating(ratingString: product.templateSuffix)
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
            self.contentView.layer.cornerRadius = 35 // Adjust to make it more oval
                    self.contentView.layer.masksToBounds = true
                    
                    self.layer.cornerRadius = 35 // Adjust to make it more oval
                    self.layer.borderWidth = 1
                    self.layer.borderColor = UIColor.black.cgColor
                    self.layer.masksToBounds = false
                    self.layer.shadowColor = UIColor.black.cgColor
                    self.layer.shadowOffset = CGSize(width: 2, height: 2)
                    self.layer.shadowOpacity = 0.5
                    self.layer.shadowRadius = 2
        }
    }
