//
//  ProductsViewModel.swift
//  EleganceHub
//
//  Created by raneem on 25/05/2024.
//

import Foundation

class ProductsViewModel{
    
    var vmResult : ProductResponse? {
        didSet {
            bindResultToViewController()
        }
    }
    var bindResultToViewController: (() -> ()) = {}

    func getProductsFromModel() {
        ProductsCall.getProducts(complationhandler:{ result, error in
            if let result = result {
                self.vmResult = result
                print("getProductsFromModel \(result.products.count)")
            }else{
                print("Error fetching products: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    )}
    
    
}
