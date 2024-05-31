//
//  productsCall.swift
//  EleganceHub
//
//  Created by raneem on 25/05/2024.
//

import Foundation

class ProductsCall{
    
    static func getProducts(collectionId: Int, completionHandler: @escaping (ProductResponse?, Error?) -> Void) {
        let urlString = "\(Constants.storeUrl)products.json?collection_id=\(collectionId)&\(Constants.accessToken)"
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
                let result = try JSONDecoder().decode(ProductResponse.self, from: data)
                completionHandler(result, nil)
            } catch let decodingError {
                print("JSON Decoding Error: \(decodingError.localizedDescription)")
                completionHandler(nil, decodingError)
            }
        }
        
        task.resume()
    }
}
