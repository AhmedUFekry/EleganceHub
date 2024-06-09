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
    func addToCartNewProduct(customerID:Int,product: Product,selectedSize:String) -> Observable<PostDraftOrderResponse> {
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
                            "title": product.title!,
                            "price": product.variants?.first?.price ?? "19",
                            "quantity": product.variants?.first?.inventory_quantity ?? "1",
                            //"sku":product.image?.src ?? "https://cdn.shopify.com/s/files/1/0880/0426/4211/collections/a340ce89e0298e52c438ae79591e3284.jpg?v=1716276581",
                            "variant_id": product.variants?.first?.id ?? -1,
                            "product_id": product.id ?? -1,
                            "properties": [
                                    ["name": "Image", "value": product.image?.src ?? "https://cdn.shopify.com/s/files/1/0880/0426/4211/collections/a340ce89e0298e52c438ae79591e3284.jpg?v=1716276581"],
                                    ["name": "Selected Size", "value": selectedSize ]
                                ]
                        ]
                    ],
//                    "applied_discount": [
//                        "description": "Custom discount",
//                        "value_type": "fixed_amount",
//                        "value": "10.0",
//                        "amount": "10.00",
//                        "title": "Custom"
//                    ],
                    "customer": [
                        "id": customerID
                    ]
                    //"use_customer_default_address": true
                ]
            ]
            print("parameterssss \(parameters)")
            AF.request(urlString, method: .post , parameters: parameters , encoding: JSONEncoding.default , headers: headers).responseData { response in
                switch response.result {
                    case .success(let data):
                        print("Response JSON: \(data)")
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: [])
                                print("Response JSON serialize: \(json)")
                                let draftResponse = try JSONDecoder().decode(PostDraftOrderResponse.self, from: data)
                                print("Draft Response: \(draftResponse)")
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
                    print("Json Response \(data)")
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
    

    
    func deleteDraftOrder(orderID: Int) -> Observable<Void> {
        return Observable.create { observer in
            let urlString = "\(Constants.storeUrl)/draft_orders/\(orderID).json"
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
    
}
    
    
