//
//  OrdersViewModel.swift
//  EleganceHub
//
//  Created by raneem on 08/06/2024.
//

import Foundation
import RxSwift
import RxRelay

class OrdersViewModel {
    var disposeBag = DisposeBag()
    let networkService:CartNetworkServiceProtocol = CartNetworkService()
    let isCompleteOrder:BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    var orderService: OrdersServiceProtocol?
    init(orderService: OrdersServiceProtocol) {
        self.orderService = orderService
    }
    
    var bindDraftOrder: (() -> Void) = {}
    var draftOrderitems: DraftOrder? {
        didSet{
            bindDraftOrder()
        }
    }
    
    var bindResultToViewController: (() -> Void) = {}
    var viewModelresult: [Order]? {
        didSet {
            bindResultToViewController()
        }
    }
    
    var bindingOrderDelete: (() -> ()) = {}
    var observableDeleteOrder: Int!{
        didSet{
            bindingOrderDelete()
        }
    }
    
    func getOrders(customerId: String) {
        orderService?.getOrders(customerId: customerId) { [weak self] result, error in
            if let result = result {
                self?.viewModelresult = result.orders
            } else {
                print("Error fetching products: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func getOrderForCustomer(orderID: Int) {
        orderService?.getDraftOrderForUser(orderID: orderID) { [weak self] result, error in
            if let draftResult = result {
                self?.draftOrderitems = draftResult.draftOrders
            }else {
                print("Error fetching products: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func deleteOrder(orderId: Int) {
        orderService?.deleteOrder(orderID: orderId){ order in
            self.observableDeleteOrder = order
            
        }
    }
   
}
