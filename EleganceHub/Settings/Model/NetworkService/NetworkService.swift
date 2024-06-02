//
//  NetworkService.swift
//  EleganceHub
//
//  Created by AYA on 02/06/2024.
//

import Foundation
import Alamofire

class NetworkService:NetworkServiceProtocol{
    static func fetchCities(country: String,completionHandler: @escaping (Result<CitiesResponse, Error>) -> Void) {
        let stringUrl = "https://countriesnow.space/api/v0.1/countries/cities"
        let parameters: [String: String] = [
            "country":country
        ]
        AF.request(stringUrl, method: .post, parameters: parameters).responseDecodable(of: CitiesResponse.self) { response in
            switch response.result {
                    case .success(let value):
                        print("Response JSON: \(value)")
                        do {
                            //let cityResponse = try JSONDecoder().decode(CitiesResponse.self, from: value as! Data)
                            print("cityResponse: \(value)")
                           completionHandler(.success(value))
                        } catch {
                            completionHandler(.failure(error))
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                        completionHandler(.failure(error))
                    }
        }
        
    }
    
    
}
