//
//  SearchViewModel.swift
//  EleganceHub
//
//  Created by Shimaa on 01/06/2024.
//

import Foundation

class SearchViewModel {
    
    var bindResultToViewController: (() -> Void) = {}
    var networkManager: NetworkServiceProtocol!
    
    var result: [ProductModel] = [] {
        didSet {
            self.bindResultToViewController()
        }
    }
    
    init(networkManager: NetworkServiceProtocol) {
        self.networkManager = networkManager
    }
    
    func getItems() {
        networkManager.getProducts(parameters: [:]) { [weak self] (response: ProductsResponse?) in
            self?.result = response?.products ?? []
        }
    }
}

