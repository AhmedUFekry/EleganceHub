//
//  SignUpNetworkService.swift
//  EleganceHub
//
//  Created by Shimaa on 30/05/2024.
//

import Foundation

protocol SignUpNetworkServiceProtocol {
    static func userRegister(newUser: User, completion: @escaping (Int, String?) -> Void)
}

class SignUpNetworkService: SignUpNetworkServiceProtocol {
    
    static func userRegister(newUser: User, completion: @escaping (Int, String?) -> Void) {
        guard let url = URL(string: "https://mad44-ism-ios1.myshopify.com/admin/api/2024-04/customers.json") else {
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("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", forHTTPHeaderField: "X-Shopify-Access-Token")

        let customerInfoDictionary = [
            "customer": [
                "first_name": newUser.first_name,
                "last_name": newUser.last_name,
                "email": newUser.email,
                //"note": "Phone: \(newUser.phone)"
            ]
        ]
        
        do {
            let httpBody = try JSONSerialization.data(withJSONObject: customerInfoDictionary, options: .prettyPrinted)
            urlRequest.httpBody = httpBody
        } catch let error {
            print("Error serializing JSON: \(error.localizedDescription)")
            completion(0, error.localizedDescription)
            return
        }

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Error during API call: \(error.localizedDescription)")
                completion(0, error.localizedDescription)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                let responseData = String(data: data ?? Data(), encoding: .utf8)
                print("Response data: \(responseData ?? "No data")")
                completion(httpResponse.statusCode, responseData)
            }
        }.resume()
    }
}
