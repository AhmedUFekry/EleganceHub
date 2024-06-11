//
//  CartNetworkServiceProtocol.swift
//  EleganceHub
//
//  Created by AYA on 08/06/2024.
//

import Foundation
import RxSwift

protocol CartNetworkServiceProtocol{
    func addToCartNewProduct(customerID:Int,product:Product,selectedSize:String) -> Observable<PostDraftOrderResponse>
    func getAllDraftOrders() -> Observable<DraftOrdersResponse>
    
    func deleteDraftOrder(orderID:Int) -> Observable<Void>
}
