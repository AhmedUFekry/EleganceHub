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
    
}
