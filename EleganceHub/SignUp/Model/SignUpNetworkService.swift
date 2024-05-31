//
//  SignUpNetworkService.swift
//  EleganceHub
//
//  Created by Shimaa on 30/05/2024.
//

import Foundation

protocol SignUpNetworkServiceProtocol {
    static func userRegister(newUser: User, completion: @escaping (Int) -> Void)
}

class SignUpNetworkService : SignUpNetworkServiceProtocol{
    static func userRegister(newUser: User, completion: @escaping (Int) -> Void) {
        let url = URL(string: "https://mad44-ism-ios1.myshopify.com/admin/api/2024-04/customers.json")
        guard let newUrl = url else {
            return
        }
        print(newUrl)
        var urlRequest = URLRequest(url: newUrl)
        urlRequest.httpMethod = "POST"
        let customerInfoDictionary = ["customer": ["first_name": newUser.first_name,
                                           "last_name" : newUser.last_name,
                                           "email": newUser.email,
                                           //"note": newCustomer.note
                                          ]]
        urlRequest.httpShouldHandleCookies = false
                do {
                    let httpBodyDictionary = try JSONSerialization.data(withJSONObject: customerInfoDictionary, options: .prettyPrinted)
                    urlRequest.httpBody = httpBodyDictionary
                    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    urlRequest.addValue("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", forHTTPHeaderField: "X-Shopify-Access-Token")
                } catch let error {
                    print(error.localizedDescription)
                }
                URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                    if let httpResponse = response as? HTTPURLResponse {
                        let response = String(data:data ?? Data(),encoding: .utf8)
                        completion(httpResponse.statusCode)
                    }
                }.resume()
    }
    
}
