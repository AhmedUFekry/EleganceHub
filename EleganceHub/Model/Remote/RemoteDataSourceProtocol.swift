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
    
    //MARK: Currency
    func fetchConversionRate(coinStr: String, completion: @escaping (Double?) -> Void) 
    
//    //MARK: Products
//    func getProducts(collectionId: Int, completionHandler: @escaping (ProductResponse?, Error?) -> Void)
//    func getProductDetails(productId: Int, handler: @escaping (ProductResponse?) -> Void)
//    
//    
//    //MARK: Home
//    func getBrands(complationhandler: @escaping (SmartCollections?,Error?) -> Void)
//    func getPriceRules(completionHandler: @escaping (Result<DiscountModel,Error>)-> Void)
//    func getDiscountCodes(discountId:String, completionHandler: @escaping (Result<DiscountCodesResponse,Error>) -> Void)
//    
//    //MARK: Orders
//    func getOrders(customerId: String, completionHandler: @escaping (OrderResponse?, Error?) -> Void)
//    func getDraftOrderForUser(orderID: Int,completionHandler: @escaping (PostDraftOrderResponse?, Error?) -> Void)
//    func completeDraftOrder(orderID: Int, completion: @escaping (Bool, Error?) -> Void)
//    
//    //MARK: Category
//    func getCategoryProducts(collectionId: String, completionHandler: @escaping (ProductResponse?, Error?) -> Void)
//    
//    //MARK: Settings
//    func updateUserData(customerID:Int,firstName:String?,lastName:String?,email:String?,phone:String?) -> Observable<CustomerResponse>
//    func getUserInfo(customerID:Int) -> Observable<CustomerResponse>
//    
//    //MARK: Profiel
//    static func fetchCities(country: String,completionHandler: @escaping (Result<CitiesResponse, Error>) -> Void)
//    
//    static func postNewAddress(customerID: Int,addressData: AddressData, completionHandler: @escaping(Result<PostAddressResponse,Error>) -> Void)
//    
//    static func getAllAddresses(customerID: Int) -> Observable<AddressDataModel>
//    
//    static func removeAddress(customerID:Int, addressID:Int) -> Observable<Void>
//    
//    func getProducts( parameters: Alamofire.Parameters, handler: @escaping (ProductsResponse?) -> Void)
//    
//    func getUsers(parameters: Parameters, handler: @escaping (UserResponse?) -> Void)
//    
//    //MARK: CART 
//    func postItemToCartNewProduct(customerID:Int,product:Product) -> Observable<PostDraftOrderResponse>
//    func getCustomerOrder(orderID:Int, completionHandler: @escaping (Result<DraftOrder, Error>) -> Void)
//    func addNewLineItemToDraftOrder(orderID: Int, updatedDraftOrder:DraftOrder) -> Observable<PostDraftOrderResponse>
//    func getDraftOrderForUser(orderID:Int) -> Observable<PostDraftOrderResponse>
//    func getAllDraftOrders() -> Observable<DraftOrdersResponse>
//    func deleteDraftOrder(orderID:Int) -> Observable<Bool>
//    
//    //MARK: SignUp
//    func userRegister(newUser: User, completion: @escaping (Int) -> Void)

}
