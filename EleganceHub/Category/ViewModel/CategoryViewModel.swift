//
//  CategoryViewModel.swift
//  EleganceHub
//
//  Created by raneem on 31/05/2024.
//

import Foundation
enum Categories : String{
    case Men = "484442636563"
    case Women = "484442669331"
    case Kids = "484442702099"
    case Sale = "484442734867"
}

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
}
