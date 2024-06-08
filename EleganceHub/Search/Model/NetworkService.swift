//
//  NetworkService.swift
//  EleganceHub
//
//  Created by Shimaa on 31/05/2024.
//

import Foundation
import Alamofire

class Network: NetworkServiceProtocol{
    func getProducts( parameters: Alamofire.Parameters, handler: @escaping (ProductsResponse?) -> Void) {
        
        let headers: HTTPHeaders = [
            "X-Shopify-Access-Token": Constants.accessTokenKey
        ]
        
        AF.request("https://mad44-ism-ios1.myshopify.com/admin/api/2024-04/products.json"
                   ,parameters: parameters, headers: headers).responseDecodable(of: ProductsResponse.self) { response in
            switch response.result {
            case .success(let data):
                print("Data retrieved successfully:")
                print(data)
                handler(data)
            case .failure(let error):
                print("Error: \(error)")
            }
            
        }
    }
}
