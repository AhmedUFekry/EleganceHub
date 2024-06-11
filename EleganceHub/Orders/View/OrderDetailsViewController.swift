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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        
        let productsNibCell = UINib(nibName: "ProductsTableViewCell", bundle: nil)
        productsOrderTableView.register(productsNibCell, forCellReuseIdentifier: "productOrderCell")
        
        orderView.applyShadow()
        setupOrder()
    }
    func setupOrder(){
        orderId.text = "\(String(describing: selctedOrder?.id!))"
        orderDate.text = selctedOrder?.createdAt
        orderPrice.text = selctedOrder?.totalPrice
        productsOrderTableView.reloadData()
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    

}

extension OrderDetailsViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = selctedOrder?.lineItems?.count ?? 3
        print("Number of rows: \(count)")
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productsCell = tableView.dequeueReusableCell(withIdentifier: "productOrderCell", for: indexPath) as! ProductsTableViewCell
        if let product = selctedOrder?.lineItems?[indexPath.section] {
            productsCell.ProductTitle?.text = product.title
            productsCell.productCategory?.text = "Quantity:\(String(describing: product.quantity))"
            productsCell.productPrice?.text = product.price
            
            let myString = product.sku ?? ""
            let myArray = myString.split(separator: ",")
            let img = String(myArray[1])
            KF.url(URL(string: img))
                .set(to: productsCell.productImage)
            
        }
        return productsCell
    }


func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 110
}
    
    
}
