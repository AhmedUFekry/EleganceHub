//
//  NetworkService.swift
//  EleganceHub
//
//  Created by AYA on 02/06/2024.
//

import Foundation
import Alamofire
import RxSwift

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
                        print("cityResponse: \(value.data)")
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
    
    static func postNewAddress(customerID: Int, addressData: AddressData, completionHandler: @escaping (Result<PostAddressResponse, Error>) -> Void) {
        let urlString = "\(Constants.storeUrl)/customers/\(customerID)/addresses.json"
        
        let headers: HTTPHeaders = [
         "X-Shopify-Access-Token": Constants.accessTokenKey,
         "Content-Type": "application/json"
        ]
        
        let parameters: Parameters = [
            "address": [
                "address1": addressData.address1,
                "address2": addressData.address1,
                "city": addressData.city,
                "company": addressData.company,
                "first_name": addressData.firstName,
                "last_name": addressData.lastName,
                "phone": addressData.phone,
                "province": addressData.province,
                "country": addressData.country,
                "zip": addressData.zip,
                "name": addressData.name,
                "province_code": addressData.provinceCode,
                "country_code": addressData.countryCode,
                "country_name": addressData.countryName
            ]
        ]
        
        AF.request(urlString,method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: PostAddressResponse.self){ response in
                switch response.result{
                    case .success(let value):
                        print("Response JSON: \(value)")
                        completionHandler(.success(value))

                    case .failure(let error):
                        print("Error: \(error)")
                    completionHandler(.failure(error))
                }
        }
    }
    
    static func getAllAddresses(customerID: Int) -> Observable<AddressDataModel> {
        return Observable.create { observer in
            let urlString = "\(Constants.storeUrl)/customers/\(customerID)/addresses.json"
            let headers: HTTPHeaders = [
                "X-Shopify-Access-Token": Constants.accessTokenKey
            ]
            
            AF.request(urlString,method: .get, encoding: JSONEncoding.default, headers: headers ).responseDecodable(of: AddressDataModel.self) { response in
                switch response.result{
                case .success(let value):
                    print("Response JSON: \(value)")
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    print("Error: \(error)")
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
