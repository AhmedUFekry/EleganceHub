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

//class SignUpNetworkService: SignUpNetworkServiceProtocol {
//    
//    static func userRegister(newUser: User, completion: @escaping (Int, String?) -> Void) {
//        guard let url = URL(string: "https://42f2d859ed1f27082b1497dddfe0771dd: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@mad44-ism-ios1.myshopify.com/admin/api/2024-04/customers.json") else {
//            return                                          //https://47f947d8be40bd3129dbe1dbc0577a11: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@mad-ism-43-1.myshopify.com/admin/api/2023-04/customers.json
//        }
//
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "POST"
////        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
////        urlRequest.addValue("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", forHTTPHeaderField: "X-Shopify-Access-Token")
//
//        let customerInfoDictionary = [
//            "customer": [
//                "first_name": newUser.first_name,
//                "last_name": newUser.last_name,
//                "email": newUser.email,
//                //"note": "Phone: \(newUser.phone)"
//            ]
//        ]
//        
//        do {
//            let httpBody = try JSONSerialization.data(withJSONObject: customerInfoDictionary, options: .prettyPrinted)
//            urlRequest.httpBody = httpBody
//            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            //urlRequest.addValue("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", forHTTPHeaderField: "X-Shopify-Access-Token")
//            print("Request prepared with body: \(String(data: httpBody, encoding: .utf8) ?? "No body")")
//
//        } catch let error {
//            print("Error serializing JSON: \(error.localizedDescription)")
//            completion(0, error.localizedDescription)
//            return
//        }
//
//        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//            if let error = error {
//                print("Error during API call: \(error.localizedDescription)")
//                completion(0, error.localizedDescription)
//                return
//            }
//
//            if let httpResponse = response as? HTTPURLResponse {
//                let responseData = String(data: data ?? Data(), encoding: .utf8)
//                print("HTTP Status Code: \(httpResponse.statusCode)")
//                print("Response data: \(responseData ?? "No data")")
//                completion(httpResponse.statusCode, responseData)
//            } else {
//                            print("Invalid response")
//                            completion(0, "Invalid response")
//            }
//        }.resume()
//    }
//}



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
