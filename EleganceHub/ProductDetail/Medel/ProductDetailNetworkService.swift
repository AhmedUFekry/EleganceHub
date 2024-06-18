//
//  ProductDetailNetworkService.swift
//  EleganceHub
//
//  Created by Shimaa on 03/06/2024.
//
import Foundation
import Alamofire

protocol DetailNetworkProtocol {
    func getProductDetails(productId: Int, handler: @escaping (ProductResponse?) -> Void)
}

class ProductDetailNetworkService: DetailNetworkProtocol {
    func getProductDetails(productId: Int, handler: @escaping (ProductResponse?) -> Void) {
        let url = "https://2f2d859ed1f27082b1497dddfe0771dd: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@mad44-ism-ios1.myshopify.com/admin/api/2024-04/products/\(productId).json"
        
        AF.request(url).responseDecodable(of: ProductResponse.self) { response in
            switch response.result {
            case .success(let data):
                print("Data retrieved successfully:")
                //print(data)
                handler(data)
            case .failure(let error):
                print("Error: \(error)")
                handler(nil)
            }
        }
    }
}



