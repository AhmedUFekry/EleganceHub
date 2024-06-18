//
//  PaymentNetworkService.swift
//  EleganceHub
//
//  Created by AYA on 15/06/2024.
//

import Foundation

class PaymentNetworkService:PaymentServiceProtocol{
    
    func completeDraftOrder(orderID: Int, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: "\(Constants.storeUrl)/draft_orders/\(orderID)/complete.json?\(Constants.accessToken)") else {
            print("Invalid URL")
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
       // request.addValue("application/json", forHTTPHeaderField: "Content-Type")

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
