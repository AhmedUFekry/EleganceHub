//
//  SettingsNetworkService.swift
//  EleganceHub
//
//  Created by AYA on 05/06/2024.
//

import Foundation
import Alamofire
import RxSwift

class SettingsNetworkService{
    
    static func updateUserData(customerID:Int,firstName:String?,lastName:String?,email:String?,phone:String?) -> Observable<CustomerResponse> {
        return Observable.create { observer in
            let urlString = "\(Constants.storeUrl)/customers/\(customerID).json"
            
            let headers: HTTPHeaders = [
             "X-Shopify-Access-Token": Constants.accessTokenKey,
             "Content-Type": "application/json"
            ]
            
            let parameters: Parameters = [
                "customer": [
                    "id": customerID,
                    "email": email ?? "",
                    "first_name": firstName ?? "",
                    "last_name": lastName ?? "",
                    "phone": phone ?? ""
                ]
            ]
                    
            print("URL: \(urlString)")
            print("Headers: \(headers)")
            print("Parameters: \(parameters)")
            
            AF.request(urlString, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData{
                response in
                    switch response.result{
                    case .success(let value):
                        print("Response JSON: \(value)")
                        do {
                           let result = try JSONDecoder().decode(CustomerResponse.self, from: value)
                           print("Customer Response: \(result)")
                            observer.onNext(result)
                            observer.onCompleted()

                        } catch(let err) {
                            observer.onError(err)
                            print(" on catch error \(err)")
                        }
                        //observer.onNext(value.data)
                        //observer.onCompleted()
                    case .failure(let error):
                        print("Error: \(error)")
                        observer.onError(error)
                    }
                }
                return Disposables.create()
        }
    }
    
    static func getUserInfo(customerID:Int) -> Observable<CustomerResponse>{
        return Observable.create { observer in
            let urlString = "\(Constants.storeUrl)/customers/\(customerID).json"
            
            let headers: HTTPHeaders = [
                "X-Shopify-Access-Token": Constants.accessTokenKey,
            ]
            AF.request(urlString, method: .get, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: CustomerResponse.self){
                response in
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
