//
//  OrdersService.swift
//  EleganceHub
//
//  Created by raneem on 09/06/2024.
//
//"\(Constants.storeUrl)customers/\(customerId)/orders.json?\(Constants.accessToken)"

import Foundation


protocol OrdersServiceProtocol {
    func getOrders(customerId: String, completionHandler: @escaping (OrderResponse?, Error?) -> Void)
    func getDraftOrderForUser(orderID: Int,completionHandler: @escaping (PostDraftOrderResponse?, Error?) -> Void)
    func deleteOrder(orderID: Int, complication:@escaping (Int) -> Void)

    //func completeDraftOrder(orderID: Int, completion: @escaping (Bool, Error?) -> Void)
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
    func deleteOrder(orderID: Int, complication: @escaping (Int) -> Void) {
        
       let url = URL(string: "https://mad44-ism-ios1.myshopify.com/admin/api/2024-04/orders/\(orderID).json?access_token=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")
        
       print("delete order\(url)")
       var urlRequest = URLRequest(url: url!)
       urlRequest.httpMethod = "DELETE"
       urlRequest.httpShouldHandleCookies = false
       URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
           if (data != nil && data?.count != 0){
               if let httpResponse = response as? HTTPURLResponse {
                   complication(httpResponse.statusCode)
               }
           }
       }.resume()
   }
}
