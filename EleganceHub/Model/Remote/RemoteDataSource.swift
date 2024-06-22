//
//  RemoteDataSource.swift
//  EleganceHub
//
//  Created by raneem on 14/06/2024.
//

import Foundation
import RxSwift
import Alamofire

class RemoteDataSource : RemoteDataSourceProtocol {
    
    static let shared = RemoteDataSource()
    
    private init() {}
    
    
    func getProducts(collectionId: Int, completionHandler: @escaping (ProductResponse?, Error?) -> Void) {
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
    
    func getBrands(complationhandler: @escaping (SmartCollections?,Error?) -> Void) {
        let url = URL(string: "\(Constants.storeUrl)smart_collections.json?since_id=482865238&\(Constants.accessToken)")
        
        guard let newUrl = url else {return}
        
        let request = URLRequest(url: newUrl)
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {return}
            
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
    
    
    func getCategoryProducts(collectionId: String, completionHandler: @escaping (ProductResponse?, Error?) -> Void) {
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

