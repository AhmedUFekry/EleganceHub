//
//  OrdersViewModel.swift
//  EleganceHub
//
//  Created by raneem on 08/06/2024.
//

import Foundation

class OrdersViewModel {

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
    
    func getOrders(customerId: String) {
        orderService?.getOrders(customerId: customerId) { [weak self] result, error in
            if let result = result {
                self?.viewModelresult = result.orders
            } else {
                print("Error fetching products: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func completeDraftOrder(orderID: Int, completion: @escaping (Bool, Error?) -> Void) {
           orderService?.completeDraftOrder(orderID: orderID) { success, error in
               completion(success, error)
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
}
