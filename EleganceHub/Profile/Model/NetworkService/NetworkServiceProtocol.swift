//
//  NetworkServiceProtocol.swift
//  EleganceHub
//
//  Created by AYA on 02/06/2024.
//

import Foundation
import RxSwift
import Alamofire

protocol NetworkServiceProtocol{
    
    static func fetchCities(country: String,completionHandler: @escaping (Result<CitiesResponse, Error>) -> Void)
    
    static func postNewAddress(customerID: Int,addressData: AddressData, completionHandler: @escaping(Result<PostAddressResponse,Error>) -> Void)
    
    static func getAllAddresses(customerID: Int) -> Observable<AddressDataModel>
    
    static func removeAddress(customerID:Int, addressID:Int) -> Observable<Void>
    
    func getProducts( parameters: Alamofire.Parameters, handler: @escaping (ProductsResponse?) -> Void)
    
    func getUsers(parameters: Parameters, handler: @escaping (UserResponse?) -> Void)
}
