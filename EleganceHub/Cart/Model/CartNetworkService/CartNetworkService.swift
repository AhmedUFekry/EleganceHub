//
//  CartNetworkService.swift
//  EleganceHub
//
//  Created by AYA on 08/06/2024.
//

import Foundation
import RxSwift
import Alamofire

class CartNetworkService:CartNetworkServiceProtocol{
    
    func postItemToCartNewProduct(customerID:Int,product: Product) -> Observable<PostDraftOrderResponse> {
        return Observable.create { observer in
            let urlString = "\(Constants.storeUrl)/draft_orders.json"
            let headers: HTTPHeaders = [
                "X-Shopify-Access-Token": Constants.accessTokenKey,
                "Content-Type": "application/json"
            ]
            
            let parameters: [String: Any] = [
                "draft_order": [
                    "line_items": [
                        [
                            "variant_id": product.variants?.first?.id ?? -1,
                            "product_id": product.id ?? -1,
                            "quantity": 1,
                            "properties": [
                                ["name": "Image","value":product.image?.src ?? "https://cdn.shopify.com/s/files/1/0880/0426/4211/collections/a340ce89e0298e52c438ae79591e3284.jpg?v=1716276581"],
                                [
                                    "name":"Quantity", "value": "\(product.variants?.first?.inventory_quantity ?? 1)"
                                ]
                            ]
                        ]
                    ],
                    "customer": [
                        "id": customerID
                    ]
                ]
            ]
            //print("parameterssss \(parameters)")
            AF.request(urlString, method: .post , parameters: parameters , encoding: JSONEncoding.default , headers: headers).responseData { response in
                switch response.result {
                    case .success(let data):
                        //print("Response JSON: \(data)")
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: [])
                                //print("Response JSON serialize: \(json)")
                                let draftResponse = try JSONDecoder().decode(PostDraftOrderResponse.self, from: data)
                               // print("Draft Response: \(draftResponse)")
                            observer.onNext(draftResponse)
                            observer.onCompleted()
                        } catch(let err) {
                            observer.onError(err)
                            print(" on catch error \(err)")
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                        observer.onError(error)
                    }
                }
                return Disposables.create()
            }
        }
    
    func getAllDraftOrders() -> Observable<DraftOrdersResponse> {
        return Observable.create { observer in
            let urlString = "\(Constants.storeUrl)/draft_orders.json"
            let headers: HTTPHeaders = [
                "X-Shopify-Access-Token": Constants.accessTokenKey
            ]
            AF.request(urlString, encoding: JSONEncoding.default,headers: headers).responseDecodable(of: DraftOrdersResponse.self) { response in
                switch response.result{
                case .success(let data):
                    //print("getAllDraftOrders Json Response \(data)")
                    observer.onNext(data)
                    observer.onCompleted()
                case .failure(let err):
                    print("Error \(err)")
                    observer.onError(err)
                }
            }
            return Disposables.create()
        }
    }
    
    func getCustomerOrder(orderID:Int, completionHandler: @escaping (Result<DraftOrder, Error>) -> Void) {
        let urlString = "\(Constants.storeUrl)/draft_orders/\(orderID).json"
        let headers: HTTPHeaders = [
            "X-Shopify-Access-Token": Constants.accessTokenKey
        ]
        AF.request(urlString,encoding: JSONEncoding.default,headers: headers).responseDecodable(of: PostDraftOrderResponse.self) { response in
            switch response.result{
                case .success(let data):
                   // print("getCustomerOrder Json Response get Order \(data)")
                guard let order = data.draftOrders else {
                    completionHandler(.failure(MyError.noDraftOrders))
                    return
                }
                    completionHandler(.success(order))
                case .failure(let err):
                    print("Error \(err)")
                    completionHandler(.failure(err))
            }
        }
    }
    
    func addNewLineItemToDraftOrder(orderID: Int, updatedDraftOrder:DraftOrder) -> Observable<PostDraftOrderResponse>{
        return Observable.create { observer in
            print("Order ID \(orderID)")
            let urlString = "\(Constants.storeUrl)/draft_orders/\(orderID).json"
            let headers: HTTPHeaders = [
                "X-Shopify-Access-Token": Constants.accessTokenKey,
                "Content-Type":"application/json"
            ]
            do {
                let jsonData = try JSONEncoder().encode(updatedDraftOrder)
                let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                    
                
               let parameters: [String: Any] = [
                "draft_order": jsonDictionary!
               ]

               AF.request(urlString, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
                   switch response.result {
                   case .success(let data):
                       
                       do {
                           let draftResponse = try JSONDecoder().decode(PostDraftOrderResponse.self, from: data)
                           //print("Draft Response: \(draftResponse)")
                           observer.onNext(draftResponse)
                           observer.onCompleted()
                       } catch {
                           //print("JSON Decoding Error: \(error)")
                           observer.onError(error)
                       }
                   case .failure(let err):
                       print("Request Error: \(err)")
                       observer.onError(err)
                   }
               }
           } catch {
               print("Error encoding parameters: \(error)")
               observer.onError(error)
           }
            return Disposables.create()
        }
    }

    func getDraftOrderForUser(orderID: Int) -> Observable<PostDraftOrderResponse> {
        return Observable.create { observer in
            let urlString = "\(Constants.storeUrl)/draft_orders/\(orderID).json"
            let headers: HTTPHeaders = [
                "X-Shopify-Access-Token": Constants.accessTokenKey
            ]
            AF.request(urlString, encoding: JSONEncoding.default,headers: headers).responseDecodable(of: PostDraftOrderResponse.self) { response in
                switch response.result{
                case .success(let data):
                   // print("getAllDraftOrders Json Response \(data)")
                    observer.onNext(data)
                    observer.onCompleted()
                case .failure(let err):
                    print("Error \(err)")
                    observer.onError(err)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func deleteDraftOrder(orderID: Int) -> Observable<Bool> {
        return Observable.create { observer in
            let urlString = "\(Constants.storeUrl)/draft_orders/\(orderID).json"
            let headers: HTTPHeaders = [
                "X-Shopify-Access-Token": Constants.accessTokenKey
            ]
            AF.request(urlString, method: .delete, encoding: JSONEncoding.default, headers: headers).response { response in
                switch response.result {
                   case .success:
                       observer.onNext(true)
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
    
    
