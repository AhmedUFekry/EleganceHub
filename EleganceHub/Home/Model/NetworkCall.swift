//
//  NetworkCall.swift
//  EleganceHub
//
//  Created by raneem on 24/05/2024.
//
import Foundation
import Alamofire


class NetworkCall: NetworkProtocol{
   
   static func getPriceRules(completionHandler: @escaping (Result<DiscountModel, Error>) -> Void) {
       guard let urlString = URL(string: "\(Constants.storeUrl)/price_rules.json") else {
           completionHandler(.failure("Invalid URL" as! Error))
               return
           }
           
           let headers: HTTPHeaders = [
            "X-Shopify-Access-Token": Constants.accessTokenKey
           ]
           
           AF.request(urlString, headers: headers).responseData { response in
               switch response.result {
               case .success(let data):
                            
                   do {
                          let discountModel = try JSONDecoder().decode(DiscountModel.self, from: data)
                          //print("Price rules: \(discountModel)")
                       completionHandler(.success(discountModel))
                   } catch {
                       completionHandler(.failure(error))
                   }
               case .failure(let error):
                   completionHandler(.failure(error))
               }
           }
    }
    
    static func getDiscountCodes(discountId:String, completionHandler: @escaping (Result<DiscountCodesResponse, Error>) -> Void) {
        let urlString = "\(Constants.storeUrl)/price_rules/\(discountId)/discount_codes.json"
        
        let headers: HTTPHeaders = [
         "X-Shopify-Access-Token": Constants.accessTokenKey
        ]
        
        AF.request(urlString, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                   let discountResponse = try JSONDecoder().decode(DiscountCodesResponse.self, from: data)
                   //print("Discount Code Response: \(discountResponse)")
                   completionHandler(.success(discountResponse))
                } catch {
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    

    
}
