//
//  ProductDetailViewModel.swift
//  EleganceHub
//
//  Created by Shimaa on 03/06/2024.
//

import Foundation
import UIKit

protocol ProductDetailViewModelProtocol {
    func getProductDetails(productId: Int)
    func getAvailableVarients(productId: Int, completion: @escaping ([String: [String]], [String]) -> Void)
}

class ProductDetailViewModel: ProductDetailViewModelProtocol {
    var bindingProduct: (() -> Void)?
    var productVariants: [Variant] = []
    
    var observableProduct: Product? {
        didSet {
            bindingProduct?()
        }
    }
    
    var networkManager: DetailNetworkProtocol
    
    init(networkManager: DetailNetworkProtocol) {
        self.networkManager = networkManager
    }
    
    func getProductDetails(productId: Int) {
        networkManager.getProductDetails(productId: productId) { [weak self] fetchProduct in
            guard let self = self else { return }
            self.observableProduct = fetchProduct?.product
            
            if let product = fetchProduct?.product {
                self.productVariants = product.variants ?? []
            } else {
                print("Failed to fetch product details")
            }
        }
    }
    
    func getAvailableVarients(productId: Int, completion: @escaping ([String: [String]], [String]) -> Void) {
        networkManager.getProductDetails(productId: productId) { fetchProduct in
            guard let variants = fetchProduct?.product?.variants else {
                print("Failed to fetch product variants")
                completion([:], [])
                return
            }
            
            var sizeColorMap: [String: [String]] = [:]
            var colors: [String] = []
            
            for variant in variants {
                if let title = variant.title {
                    let components = title.components(separatedBy: "/")
                    if components.count == 2 {
                        let size = components.first?.trimmingCharacters(in: .whitespaces) ?? ""
                        let color = components.last?.trimmingCharacters(in: .whitespaces) ?? ""
                        sizeColorMap[size, default: []].append(color)
                        if !colors.contains(color) {
                            colors.append(color)
                        }
                    }
                }
            }
            
            print("Size-Color Map: \(sizeColorMap)")
            print("Available Colors: \(colors)")
            
            completion(sizeColorMap, colors)
        }
    }
}

