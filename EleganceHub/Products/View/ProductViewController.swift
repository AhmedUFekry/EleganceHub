//
//  ProductViewController.swift
//  EleganceHub
//
//  Created by raneem on 25/05/2024.
//

import UIKit
import Kingfisher

class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var appBar: CustomAppBarUIView!
    @IBOutlet weak var brandName: UILabel!
    
    @IBOutlet weak var productsTableView: UITableView!
    var brandsId: Int?
    var brandsName: String?

    var productArray: [Product]?
    var productsViewModel = ProductsViewModel()
    var currencyViewModel = CurrencyViewModel()
    var rate : Double!
    var userCurrency :String?
    
    override func viewWillAppear(_ animated: Bool) {
       rate = UserDefaultsHelper.shared.getDataDoubleFound(key: UserDefaultsConstants.currencyRate.rawValue)
        userCurrency = UserDefaultsHelper.shared.getCurrencyFromUserDefaults()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        appBar.lableTitle.text = brandsName
        appBar.secoundTrailingIcon.isHidden = true
        appBar.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
     
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.separatorStyle = .none
        
        let productsNibCell = UINib(nibName: "ProductsTableViewCell", bundle: nil)
        productsTableView.register(productsNibCell, forCellReuseIdentifier: "productsCell")
        
        productsViewModel.bindResultToViewController = { [weak self] in
            guard let self = self else { return }
            self.productArray = self.productsViewModel.vmResult
            self.renderView()
        }
        
        productsViewModel.getProductsFromModel(collectionId: brandsId ?? 484442308883)
        //brandName.text = brandsName
        
    }
    
    func renderView() {
        DispatchQueue.main.async {
            print("Reloading table view data")
            self.productsTableView.reloadData()
        }
    }
    @objc func goBack() {
               self.navigationController?.popViewController(animated: true)
           }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = productArray?.count ?? 0
        print("Number of sections: \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productsCell = tableView.dequeueReusableCell(withIdentifier: "productsCell", for: indexPath) as! ProductsTableViewCell
        
        if let product = productArray?[indexPath.section] {
            if let title = product.title {
                
                let components = title.split(separator: "|")
                let remainingTitle = components.dropFirst().joined(separator: "|")
                productsCell.ProductTitle?.text = remainingTitle.isEmpty ? nil : remainingTitle
            }
            productsCell.productCategory?.text = product.productType
            
            let convertedPrice = convertPrice(price: product.variants?[0].price ?? "2", rate: self.rate)
            
            productsCell.productPrice.text = "\(String(format: "%.2f", convertedPrice)) \(userCurrency ?? "USD")"
            
            KF.url(URL(string: product.image?.src ?? "https://cdn.shopify.com/s/files/1/0880/0426/4211/collections/a340ce89e0298e52c438ae79591e3284.jpg?v=1716276581"))
                .set(to: productsCell.productImage)
        }
        return productsCell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let product = productArray?[indexPath.section] {
            navigateToProductDetail(product: product)
        }
    }
    
    func navigateToProductDetail(product: Product) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let productDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController {
            productDetailVC.productId = product.id
            navigationController?.pushViewController(productDetailVC, animated: true)
        }
    }
}
