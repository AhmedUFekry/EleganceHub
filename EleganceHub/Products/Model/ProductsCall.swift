//
//  productsCall.swift
//  EleganceHub
//
//  Created by raneem on 25/05/2024.
//

import Foundation
class ProductsCall{
    //https://mad-ism-and.myshopify.com/admin/api/2024-04/products.json?collection_id=437390377195&access_token=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
    
    
    static func getProducts(complationhandler: @escaping (ProductResponse?,Error?) -> Void) {
        let url = URL(string: "\(Constants.storeUrl)products.json?collection_id=437390377195&\(Constants.accessToken)")
        
        print("getProducts \(url)")
        guard let newUrl = url else {return}
        
        let request = URLRequest(url: newUrl)
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {return}
            print("getProducts data has arrived \(data.count)")
            
            do {
                let result = try JSONDecoder().decode(ProductResponse.self, from:data)
                complationhandler(result,nil)
            }catch let error {
                print(error.localizedDescription)
                complationhandler(nil,error)
            }
        }
        
        task.resume()
    }
}
