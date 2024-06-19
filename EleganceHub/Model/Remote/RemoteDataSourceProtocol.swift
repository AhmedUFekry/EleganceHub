//
//  RemoteDataSourceProtocol.swift
//  EleganceHub
//
//  Created by raneem on 14/06/2024.
//

import Foundation
import RxSwift
import Alamofire

protocol RemoteDataSourceProtocol{
    
    
    //MARK: Products
    func getProducts(collectionId: Int, completionHandler: @escaping (ProductResponse?, Error?) -> Void)
    
    //MARK: Home
    func getBrands(complationhandler: @escaping (SmartCollections?,Error?) -> Void)
    
    //MARK: Category
    func getCategoryProducts(collectionId: String, completionHandler: @escaping (ProductResponse?, Error?) -> Void)
    
    
    //    //MARK: Orders
    //    func getOrders(customerId: String, completionHandler: @escaping (OrderResponse?, Error?) -> Void)
    //    func completeDraftOrder(orderID: Int, completion: @escaping (Bool, Error?) -> Void)
    //    func deleteOrder(orderID: Int, complication:@escaping (Int) -> Void)
    //
    //
    
    
    
    
}
