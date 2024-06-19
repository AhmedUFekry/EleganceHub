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
    
    static func getDiscountCodes(discountId:Int, completionHandler: @escaping (Result<DiscountCodesResponse, Error>) -> Void) {
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
    
    
    static func getBrands(complationhandler: @escaping (SmartCollections?,Error?) -> Void) {
        let url = URL(string: "\(Constants.storeUrl)smart_collections.json?since_id=482865238&\(Constants.accessToken)")
        
        guard let newUrl = url else {return}
        
        let request = URLRequest(url: newUrl)
        
        let session = URLSession(configuration: .default)
      
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {return}
            
            do {
                let result = try JSONDecoder().decode(SmartCollections.self, from:data)
                complationhandler(result,nil)
                }catch let error {
                    print(error.localizedDescription)
                    complationhandler(nil,error)
            }
        }
        
        task.resume()
    }
    
    
}
