//
//  ProductsViewModel.swift
//  EleganceHub
//
//  Created by raneem on 25/05/2024.
//


import Foundation

class ProductsViewModel {
    
    
    
    var vmResult: [Product]? {
        didSet {
            bindResultToViewController()
        }
    }
    var bindResultToViewController: (() -> ()) = {}
    
    func getProductsFromModel(collectionId:Int) {
        ProductsCall.getProducts(collectionId: collectionId) {[weak self] result, error in
            if let result = result {
                self?.vmResult = result.products
            }else {
                print("Error fetching products: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

