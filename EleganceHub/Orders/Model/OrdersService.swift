//
//  OrdersService.swift
//  EleganceHub
//
//  Created by raneem on 09/06/2024.
//
//"\(Constants.storeUrl)customers/\(customerId)/orders.json?\(Constants.accessToken)"

import Foundation

import RxSwift
import Alamofire

protocol OrdersServiceProtocol {
    func getOrders(customerId: String, completionHandler: @escaping (OrderResponse?, Error?) -> Void)
    func getDraftOrderForUser(orderID: Int,completionHandler: @escaping (PostDraftOrderResponse?, Error?) -> Void)
    func completeDraftOrder(orderID: Int, completion: @escaping (Bool, Error?) -> Void)
}

class OrdersService: OrdersServiceProtocol {
  
    
    
    func getOrders(customerId: String, completionHandler: @escaping (OrderResponse?, Error?) -> Void) {
        
 //"https://mad44-ism-ios1.myshopify.com/admin/api/2024-04/orders.json?&access_token=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"
        
        guard let urlString = URL(string: "\(Constants.storeUrl)customers/\(customerId)/orders.json?\(Constants.accessToken)") else {
            print("Invalid URL")
            return
        }
                
        let request = URLRequest(url: urlString)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching orders: \(error.localizedDescription)")
                completionHandler(nil, error)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completionHandler(nil, NSError(domain: "NoDataError", code: -1, userInfo: nil))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(OrderResponse.self, from: data)
                print("OrderResponse: \(result)")
                completionHandler(result, nil)
            } catch let decodingError {
                print("JSON Decoding Error: \(decodingError.localizedDescription)")
                completionHandler(nil, decodingError)
            }
        }
        
        task.resume()
    }
    
    func getDraftOrderForUser(orderID: Int,completionHandler: @escaping (PostDraftOrderResponse?, Error?) -> Void) {
               
        
        
               guard let urlString = URL(string: "\(Constants.storeUrl)draft_orders/\(orderID).json?\(Constants.accessToken)") else {
                   print("Invalid URL")
                   return
               }
               print("aloooo \(urlString)")
                       
               let request = URLRequest(url: urlString)
               let session = URLSession(configuration: .default)
               let task = session.dataTask(with: request) { data, response, error in
                   if let error = error {
                       print("Error fetching orders: \(error.localizedDescription)")
                       completionHandler(nil, error)
                       return
                   }
                   
                   guard let data = data else {
                       print("No data received")
                       completionHandler(nil, NSError(domain: "NoDataError", code: -1, userInfo: nil))
                       return
                   }
                   
                   do {
                       let result = try JSONDecoder().decode(PostDraftOrderResponse.self, from: data)
                       print("DraftOrderResponse: \(result)")
                       completionHandler(result, nil)
                   } catch let decodingError {
                       print("JSON Decoding Error: \(decodingError.localizedDescription)")
                       completionHandler(nil, decodingError)
                   }
               }
               
               task.resume()
           }
    

    func completeDraftOrder(orderID: Int, completion: @escaping (Bool, Error?) -> Void) {
            guard let url = URL(string: "\(Constants.storeUrl)/draft_orders/\(orderID)/complete.json?\(Constants.accessToken)") else {
                print("Invalid URL")
                completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(false, error)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if (200...299).contains(httpResponse.statusCode) {
                        print("Draft order completed successfully")
                        completion(true, nil)
                    } else {
                        print("Failed with status code: \(httpResponse.statusCode)")
                        let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed with status code: \(httpResponse.statusCode)"])
                        completion(false, error)
                    }
                }
            }
            task.resume()
        }

    

}
