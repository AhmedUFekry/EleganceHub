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
    func getAvailableSizes(productId: Int, completion: @escaping ([String]) -> Void)
    func getAvailableSizesAndColors(productId: Int, completion: @escaping ([String: [UIColor]]?) -> Void)
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
                
            } else {
                print("Failed to fetch product details")
            }
        }
    }
    
    func getAvailableSizes(productId: Int, completion: @escaping ([String]) -> Void) {
            networkManager.getProductDetails(productId: productId) { [weak self] fetchProduct in
                guard let variants = fetchProduct?.product?.variants else {
                    print("Failed to fetch product variants")
                    completion([])
                    return
                }
                let sizes = variants.compactMap { $0.title?.components(separatedBy: "/").first }
                print("Available sizes: \(sizes)")
                completion(sizes)
            }
        }
        
    func getAvailableSizesAndColors(productId: Int, completion: @escaping ([String: [UIColor]]?) -> Void) {
        guard !productVariants.isEmpty else {
            completion(nil)
            return
        }
        
        var sizes: [String] = []
        var colors: [[String]] = []
        
        for variant in productVariants {
            if let title = variant.title {
                let size = title.components(separatedBy: "/").first ?? ""
                sizes.append(size)
                
                if let color = title.components(separatedBy: "/").last {
                    let trimmedColor = color.trimmingCharacters(in: .whitespaces)
                    if let index = sizes.firstIndex(of: size) {
                        if index < colors.count {
                            colors[index].append(trimmedColor)
                        } else {
                            colors.append([trimmedColor])
                        }
                    }
                }
            }
        }
        
        let colorObjects = colors.map { colorArray -> [UIColor] in
            return colorArray.map { colorString -> UIColor in
                return UIColor(named: colorString) ?? UIColor.black
            }
        }
        
        
        var sizesAndColors: [String: [UIColor]] = [:]
        for i in 0..<sizes.count {
            sizesAndColors[sizes[i]] = colorObjects[i]
        }
        
        completion(sizesAndColors)
    }

    }


