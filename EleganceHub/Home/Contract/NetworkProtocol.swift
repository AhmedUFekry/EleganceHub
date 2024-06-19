//
//  NetworkProtocol.swift
//  EleganceHub
//
//  Created by AYA on 30/05/2024.
//

import Foundation

protocol NetworkProtocol{
    static func getBrands(complationhandler: @escaping (SmartCollections?,Error?) -> Void)
    
    static func getPriceRules(completionHandler: @escaping (Result<DiscountModel,Error>)-> Void)
    static func getDiscountCodes(discountId:Int, completionHandler: @escaping (Result<DiscountCodesResponse,Error>) -> Void)
    
}

