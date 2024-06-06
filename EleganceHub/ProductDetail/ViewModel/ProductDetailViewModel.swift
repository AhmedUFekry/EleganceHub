//
//  ProductDetailViewModel.swift
//  EleganceHub
//
//  Created by Shimaa on 03/06/2024.
//



//        let apiUrl = "https://2f2d859ed1f27082b1497dddfe0771dd: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@mad44-ism-ios1.myshopify.com/admin/api/2024-04/products/9425665655059.json"
//
//        "https://2f2d859ed1f27082b1497dddfe0771dd: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@mad44-ism-ios1.myshopify.com/admin/api/2024-04/products/\(productId).json"


import Foundation
import UIKit

protocol ProductDetailViewModelProtocol {
    func getProductDetails(productId: Int)
    func getAvailableSizesAndColors(productId: Int, completion: @escaping ([String: [String]], [String]) -> Void)
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
            self?.observableProduct = fetchProduct?.product
            
            if let product = fetchProduct?.product {
                print("Product ID: \(product.id ?? 0)")
                print("Product Title: \(product.title ?? "No title")")
                print("Product Description: \(product.bodyHTML ?? "No description")")
                
                self?.productVariants = product.variants ?? []
            } else {
                print("Failed to fetch product details")
            }
        }
    }
    
    func getAvailableSizesAndColors(productId: Int, completion: @escaping ([String: [String]], [String]) -> Void) {
        networkManager.getProductDetails(productId: productId) { [weak self] fetchProduct in
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
