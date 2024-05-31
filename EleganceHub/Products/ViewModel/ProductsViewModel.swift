//
//  ProductsViewModel.swift
//  EleganceHub
//
//  Created by raneem on 25/05/2024.
//

import Foundation


import Foundation

class ProductsViewModel {
    var vmResult: [Product]? {
        didSet {
            bindResultToViewController()
        }
    }
    var bindResultToViewController: (() -> ()) = {}
    
    func getProductsFromModel(collectionId:Int) {
        ProductsCall.getProducts(collectionId: collectionId) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.vmResult = result.products
                    print("ProductsViewModel \(result.products.count)")
                }
            } else {
                print("Error fetching products: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

