//
//  OrdersViewModel.swift
//  EleganceHub
//
//  Created by raneem on 08/06/2024.
//

import Foundation

class OrdersViewModel {
    var orderService:OrdersServiceProtocol?
    init(orderService:OrdersServiceProtocol) {
        self.orderService = orderService
    }
    
    var bindResultToViewController : (()->()) = {}
    var viewModelresult : [Order]?{
        didSet{
            bindResultToViewController()
        }
    }
    
    func getOrders(customerId:String){
        orderService?.getOrders(customerId: customerId){[weak self] result, error in
            if let result = result {
                self?.viewModelresult = result.orders
            }else {
                print("Error fetching products: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
