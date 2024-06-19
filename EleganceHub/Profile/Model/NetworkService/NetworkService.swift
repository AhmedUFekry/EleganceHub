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
                    print("cityResponse: \(value.data)")
                    completionHandler(.success(value))
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
    
    static func removeAddress(customerID: Int, addressID: Int) -> Observable<Void>{
        return Observable.create { observer in
            let urlString = "\(Constants.storeUrl)/customers/\(customerID)/addresses/\(addressID).json"
            let headers: HTTPHeaders = [
                "X-Shopify-Access-Token": Constants.accessTokenKey
            ]
            AF.request(urlString, method: .delete, encoding: JSONEncoding.default, headers: headers).response { response in
                switch response.result {
                   case .success:
                       observer.onNext(())
                       observer.onCompleted()
                   case .failure(let error):
                       print("Error: \(error)")
                       observer.onError(error)
                   }
               }
               return Disposables.create()
        }
    }
    
    func getProducts( parameters: Alamofire.Parameters, handler: @escaping (ProductsResponse?) -> Void) {
        
        let headers: HTTPHeaders = [
            "X-Shopify-Access-Token": Constants.accessTokenKey
        ]
        
        AF.request("https://mad44-ism-ios1.myshopify.com/admin/api/2024-04/products.json"
                   ,parameters: parameters, headers: headers).responseDecodable(of: ProductsResponse.self) { response in
            switch response.result {
            case .success(let data):
                print("Data retrieved successfully:")
                print(data)
                handler(data)
            case .failure(let error):
                print("Error: \(error)")
            }
            
        }
    }
    

    func getUsers(parameters: Parameters, handler: @escaping (UserResponse?) -> Void) {
        let headers: HTTPHeaders = [
            "X-Shopify-Access-Token": "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"
        ]
        
        AF.request("https://mad44-ism-ios1.myshopify.com/admin/api/2024-04/customers.json", parameters: parameters, headers: headers).responseDecodable(of: UserResponse.self) { response in
            switch response.result {
            case .success(let data):
                print("Data retrieved successfully:")
                print(data)
                handler(data)
            case .failure(let error):
                print("Error: \(error)")
                handler(nil)
            }
        }
    }

}
