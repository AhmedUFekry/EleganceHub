//
//  NetworkCall.swift
//  EleganceHub
//
//  Created by raneem on 24/05/2024.
//
import Foundation


class NetworkCall{
    static func getBrands(complationhandler: @escaping (SmartCollections?,Error?) -> Void) {
        
        let url = URL(string: "\(Constants.storeUrl)smart_collections.json?since_id=482865238&access_token=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")
        print(url)
        guard let newUrl = url else {return}
        
        let request = URLRequest(url: newUrl)
        
        let session = URLSession(configuration: .default)
      
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {return}
            print("whoooo data has arrived \(data.count)")
            
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
