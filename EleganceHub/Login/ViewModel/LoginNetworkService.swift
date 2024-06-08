////
////  LoginNetworkService.swift
////  EleganceHub
////
////  Created by Shimaa on 08/06/2024.
////
//
//import Foundation
//import Alamofire
//
//protocol LoginNetworkServiceProtocol {
//    func getUsers(parameters: Parameters, handler: @escaping (UserResponse?) -> Void)
//}
//
//class LoginNetworkService: LoginNetworkServiceProtocol {
//    func getUsers(parameters: Parameters, handler: @escaping (UserResponse?) -> Void) {
//        let headers: HTTPHeaders = [
//            "X-Shopify-Access-Token": "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"
//        ]
//        
//        AF.request("https://mad44-ism-ios1.myshopify.com/admin/api/2024-04/customers.json", parameters: parameters, headers: headers).responseDecodable(of: UserResponse.self) { response in
//            switch response.result {
//            case .success(let data):
//                print("Data retrieved successfully:")
//                print(data)
//                handler(data)
//            case .failure(let error):
//                print("Error: \(error)")
//                handler(nil)
//            }
//        }
//    }
//}
