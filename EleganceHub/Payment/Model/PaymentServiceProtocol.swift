//
//  PaymentServiceProtocol.swift
//  EleganceHub
//
//  Created by AYA on 15/06/2024.
//

import Foundation

protocol PaymentServiceProtocol{
    func completeDraftOrder(orderID: Int, completion: @escaping (Bool, Error?) -> Void)
}
