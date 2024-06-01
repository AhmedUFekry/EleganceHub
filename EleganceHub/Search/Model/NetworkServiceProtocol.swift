//
//  NetworkServiceProtocol.swift
//  EleganceHub
//
//  Created by Shimaa on 31/05/2024.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol{
    func getProducts(parameters: Alamofire.Parameters, handler: @escaping (ProductsResponse?) -> Void)
}
