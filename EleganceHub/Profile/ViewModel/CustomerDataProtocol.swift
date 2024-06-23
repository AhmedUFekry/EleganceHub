//
//  CustomerDataProtocol.swift
//  EleganceHub
//
//  Created by AYA on 09/06/2024.
//

import Foundation
import RxSwift

protocol CustomerDataProtocol{
    var customerResponse: PublishSubject<CustomerResponse> { get }
    var error: PublishSubject<Error> { get }
    var savedImage: UIImage? { get }
    func loadUSerData(customerID:Int)
    func updateData(customerID:Int,firstName:String?,lastName:String?,email:String?,phone:String?)
    
    func loadImage()
    func saveImage(_ image: UIImage)
    func clearLoggedInImage()
    
    var rateClosure : (Double)->Void {get set}
    func getRate(currencyType:String)
}
