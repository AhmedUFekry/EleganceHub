//
//  CategoryViewModel.swift
//  EleganceHub
//
//  Created by raneem on 31/05/2024.
//

import Foundation

class CategoryViewModel {
    var bindResultToViewController : (()->()) = {}
    
    var categoryResult : [Product]!{
        didSet{
            bindResultToViewController()
        }
    }
    
    
    func getCategoryProducts(category: Categories){
        CategoryCall.getCategoryProducts(collectionId: category.rawValue) {[weak self] result, error in if let result = result {
            self?.categoryResult = result.products
            }else {
                print("Error fetching products:\(error?.localizedDescription ?? "Unknown error")")
                
            }
        }
    }
    
    
    func filterCategory(filterType: String) -> [Product] {
        let productsCopy = categoryResult
        let filterList = productsCopy?.filter{$0.productType == filterType}
        return filterList ?? []
    }

}
