//
//  ProductViewController.swift
//  EleganceHub
//
//  Created by raneem on 25/05/2024.
//

import UIKit

class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var productsTableView: UITableView!
    
    var productArray: ProductResponse?
    var productsViewModel = ProductsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productsTableView.delegate = self
        productsTableView.dataSource = self

        let productsNibCell = UINib(nibName: "ProductsTableViewCell", bundle: nil)
        productsTableView.register(productsNibCell, forCellReuseIdentifier: "productsCell")
        
        productsViewModel.bindResultToViewController = { [weak self] in
            guard let self = self else { return }
            self.productArray = self.productsViewModel.vmResult
            self.renderView()
        }

        productsViewModel.getProductsFromModel()
    }
    
    func renderView() {
        DispatchQueue.main.async {
            print("Reloading table view data")
            self.productsTableView.reloadData()
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        let count = productArray?.products.count ?? 9
        print("Number of sections: \(count)")
        return count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productsCell = tableView.dequeueReusableCell(withIdentifier: "productsCell", for: indexPath) as! ProductsTableViewCell
        if let product = productArray?.products[indexPath.section] {
            productsCell.ProductTitle?.text = product.handle
            productsCell.productCategory?.text = product.title
            print("Product at section \(indexPath.section): \(product.title)")
        } else {
            print("No product found for section \(indexPath.section)")
        }
        return productsCell
    }
}
