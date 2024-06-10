//
//  CartViewModelProtocol.swift
//  EleganceHub
//
//  Created by AYA on 08/06/2024.
//

import Foundation
import RxSwift
import RxRelay

protocol CartViewModelProtocol{
    var productItem:PublishSubject<PostDraftOrderResponse> { get set }
    var isLoading: BehaviorRelay<Bool> { get set }
    var error: PublishSubject<Error> { get set }
    var draftOrdersList: PublishSubject<[DraftOrder]> {get set}
    
    func addToCart(customerID:Int,product: Product,selectedSize:String)
    
    func getAllDraftOrdersForUser(customerID:Int)
    
    func deleteDraftOrder(orderID:Int,customerID:Int)
}
