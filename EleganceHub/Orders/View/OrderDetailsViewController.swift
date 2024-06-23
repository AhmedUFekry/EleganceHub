//
//  OrderDetailsViewController.swift
//  EleganceHub
//
//  Created by raneem on 09/06/2024.
//

import UIKit
import Kingfisher

class OrderDetailsViewController: UIViewController {
    var selctedOrder : Order?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var productsOrderTableView: UITableView!
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderId: UILabel!
    
    var currencyViewModel = CurrencyViewModel()
    let rate:Double = UserDefaultsHelper.shared.getDataDoubleFound(key: UserDefaultsConstants.currencyRate.rawValue)
    let userCurrency = UserDefaultsHelper.shared.getCurrencyFromUserDefaults().uppercased()
        override func viewDidLoad() {
            super.viewDidLoad()
            
            activityIndicator.startAnimating()
            
            let productsNibCell = UINib(nibName: "ProductsTableViewCell", bundle: nil)
            productsOrderTableView.register(productsNibCell, forCellReuseIdentifier: "productOrderCell")
            
            orderView.applyShadow()
        }
        
        func setupOrder() {
            guard let order = selctedOrder else { return }
            
            orderId.text = "\(order.id ?? 1)"
            orderDate.text = order.createdAt?.split(separator: "T").first.map(String.init)
           
            let convertedPrice = convertPrice(price: order.totalPrice ?? "2", rate: rate)
            orderPrice.text = "\(String(format: "%.2f", convertedPrice)) \(userCurrency)"
            
            productsOrderTableView.reloadData()
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }

    extension OrderDetailsViewController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return selctedOrder?.lineItems?.count ?? 3
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let productsCell = tableView.dequeueReusableCell(withIdentifier: "productOrderCell", for: indexPath) as! ProductsTableViewCell
            
            if let product = selctedOrder?.lineItems?[indexPath.section] {
                productsCell.ProductTitle?.text = product.title
                productsCell.productCategory?.text = "Quantity: \(product.quantity ?? 2)"
                productsCell.productPrice?.text = product.price
                
                let placeholderImage = UIImage(named: "adidas")
                if let imageURL = product.properties?.first {
                    productsCell.productImage.kf.setImage(with: URL(string: imageURL.value ?? ""), placeholder: placeholderImage)
                } else {
                    productsCell.productImage.image = placeholderImage
                }
            }
            return productsCell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 110
        }
    }
