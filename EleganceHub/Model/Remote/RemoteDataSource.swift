//
//  RemoteDataSource.swift
//  EleganceHub
//
//  Created by raneem on 14/06/2024.
//

import Foundation
import RxSwift
import Alamofire

class RemoteDataSource : RemoteDataSourceProtocol {
    
    static let shared = RemoteDataSource()
    
    private init() {}
    
    func fetchConversionRate(coinStr: String, completion: @escaping (Double?) -> Void) {
        
        let urlStr = "https://v6.exchangerate-api.com/v6/f0c99b265f25de45353fe2bc/latest/USD"
            guard let url = URL(string: urlStr) else {
                completion(nil)
                print("Invalid URL")
                return
            }
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(nil)
                    print("fetchConversionRate error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    completion(nil)
                    print("fetchConversionRate error: No data")
                    return
                }
                
                print("Received data: \(String(data: data, encoding: .utf8) ?? "N/A")")
                
                do {
                    let jsonDecoder = JSONDecoder()
                    
                    let decodedData = try jsonDecoder.decode(CurrencyModel.self, from: data)
                    print(decodedData)
                    if let rate = decodedData.conversionRates[coinStr] {
                        print("rate, ",rate)
                        completion(rate)
                    } else {
                        completion(nil)
                        print("fetchConversionRate error: Rate not found for \(coinStr)")
                    }
                } catch {
                    completion(nil)
                    print("fetchConversionRate error: \(error.localizedDescription)")
                }
            }
            task.resume()
        }
    
    
//    func getProducts(collectionId: Int, completionHandler: @escaping (ProductResponse?, (any Error)?) -> Void) {
//        <#code#>
//    }
//    
//    func getProductDetails(productId: Int, handler: @escaping (ProductResponse?) -> Void) {
//        <#code#>
//    }
//    
//    func getBrands(complationhandler: @escaping (SmartCollections?, (any Error)?) -> Void) {
//        <#code#>
//    }
//    
//    func getPriceRules(completionHandler: @escaping (Result<DiscountModel, any Error>) -> Void) {
//        <#code#>
//    }
//    
//    func getDiscountCodes(discountId: String, completionHandler: @escaping (Result<DiscountCodesResponse, any Error>) -> Void) {
//        <#code#>
//    }
//    
//    func getOrders(customerId: String, completionHandler: @escaping (OrderResponse?, (any Error)?) -> Void) {
//        <#code#>
//    }
//    
//    func getDraftOrderForUser(orderID: Int, completionHandler: @escaping (PostDraftOrderResponse?, (any Error)?) -> Void) {
//        <#code#>
//    }
//    
//    func completeDraftOrder(orderID: Int, completion: @escaping (Bool, (any Error)?) -> Void) {
//        <#code#>
//    }
//    
//    func getCategoryProducts(collectionId: String, completionHandler: @escaping (ProductResponse?, (any Error)?) -> Void) {
//        <#code#>
//    }
//    
//    func updateUserData(customerID: Int, firstName: String?, lastName: String?, email: String?, phone: String?) -> RxSwift.Observable<CustomerResponse> {
//        <#code#>
//    }
//    
//    func getUserInfo(customerID: Int) -> RxSwift.Observable<CustomerResponse> {
//        <#code#>
//    }
//    
//    static func fetchCities(country: String, completionHandler: @escaping (Result<CitiesResponse, any Error>) -> Void) {
//        <#code#>
//    }
//    
//    static func postNewAddress(customerID: Int, addressData: AddressData, completionHandler: @escaping (Result<PostAddressResponse, any Error>) -> Void) {
//        <#code#>
//    }
//    
//    static func getAllAddresses(customerID: Int) -> RxSwift.Observable<AddressDataModel> {
//        <#code#>
//    }
//    
//    static func removeAddress(customerID: Int, addressID: Int) -> RxSwift.Observable<Void> {
//        <#code#>
//    }
//    
//    func getProducts(parameters: Alamofire.Parameters, handler: @escaping (ProductsResponse?) -> Void) {
//        <#code#>
//    }
//    
//    func getUsers(parameters: Alamofire.Parameters, handler: @escaping (UserResponse?) -> Void) {
//        <#code#>
//    }
//    
//    func postItemToCartNewProduct(customerID: Int, product: Product) -> RxSwift.Observable<PostDraftOrderResponse> {
//        <#code#>
//    }
//    
//    func getCustomerOrder(orderID: Int, completionHandler: @escaping (Result<DraftOrder, any Error>) -> Void) {
//        <#code#>
//    }
//    
//    func addNewLineItemToDraftOrder(orderID: Int, updatedDraftOrder: DraftOrder) -> RxSwift.Observable<PostDraftOrderResponse> {
//        <#code#>
//    }
//    
//    func getDraftOrderForUser(orderID: Int) -> RxSwift.Observable<PostDraftOrderResponse> {
//        <#code#>
//    }
//    
//    func getAllDraftOrders() -> RxSwift.Observable<DraftOrdersResponse> {
//        <#code#>
//    }
//    
//    func deleteDraftOrder(orderID: Int) -> RxSwift.Observable<Bool> {
//        <#code#>
//    }
//    
//    func userRegister(newUser: User, completion: @escaping (Int) -> Void) {
//        <#code#>
//    }
//    
//    
}

