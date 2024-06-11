//
//  OrdersService.swift
//  EleganceHub
//
//  Created by raneem on 09/06/2024.
//

import Foundation

protocol OrdersServiceProtocol{
    func getOrders(customerId: String, completionHandler: @escaping (OrderResponse?, Error?) -> Void)
}

class OrdersService:OrdersServiceProtocol{
    func getOrders(customerId: String, completionHandler: @escaping (OrderResponse?, (any Error)?) -> Void) {
        let urlString = "\(Constants.storeUrl)customers/\(customerId)/orders.json?\(Constants.accessToken)"
       print(urlString)
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
                
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching products: \(error.localizedDescription)")
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
                completionHandler(result, nil)
                print(result.orders?.first?.lineItems   )
            } catch let decodingError {
                print("JSON Decoding Error: \(decodingError.localizedDescription)")
                completionHandler(nil, decodingError)
            }
        }
        
        task.resume()
    }
    
    
}
