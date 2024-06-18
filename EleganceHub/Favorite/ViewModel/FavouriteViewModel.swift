//
//  FavouriteViewModel.swift
//  EleganceHub
//
//  Created by AYA on 18/06/2024.
//

import Foundation

class FavouriteViewModel{
    private let networkService:DetailNetworkProtocol = ProductDetailNetworkService()
    
    
    var observableProduct: Product? {
        didSet {
            bindingProduct?()
        }
    }
    var bindingProduct: (() -> Void)?

    func getProductDetails(productId: Int) {
        networkService.getProductDetails(productId: productId) { [weak self] fetchProduct in
            guard let self = self else { return }
            self.observableProduct = fetchProduct?.product
            
        }
    }
}
