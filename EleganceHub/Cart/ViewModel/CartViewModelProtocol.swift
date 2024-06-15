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
    //var productItem:PublishSubject<PostDraftOrderResponse> { get set }
    var isLoading: BehaviorRelay<Bool> { get set }
    var error: PublishSubject<Error> { get set }
    var lineItemsList: PublishSubject<[LineItem]> {get set}
    var draftOrder: PublishSubject<DraftOrder>{get set}
    var isValiedCopoun: BehaviorRelay<Bool> {get set}
    
    //func addToCart(customerID:Int,product: Product,selectedSize:String)
    
    func getDraftOrderForUser(orderID:Int)
    func deleteItemFromDraftOrder(orderID:Int, itemID:Int)
    func deleteDraftOrder(orderID:Int)
    
    func decremantQuantity(at index: Int)
    func incrementQuantity(at index: Int)
    func updateLatestListItem(orderID:Int)
    
    func checkForCopuns(copunsString:String, draftOrder:DraftOrder)
}
