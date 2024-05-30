//
//  ViewModelProtocol.swift
//  EleganceHub
//
//  Created by AYA on 30/05/2024.
//

import Foundation

protocol ViewModelProtocol{
    var vmResult : SmartCollections?{ get set}
    var bindResultToViewController: (() -> ()) {get set}
    func getBrandsFromModel()
    
    var couponsResult: [DiscountCodes]? {get set}
    var bindCouponsToViewController: (() -> ()) {get set}
    func getCouponsFromModel()
    
    var failureIngetData:((_ err: String) -> ()) {get set}
}
