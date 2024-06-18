//
//  PaymentMethodModel.swift
//  EleganceHub
//
//  Created by AYA on 25/05/2024.
//

import Foundation

struct PaymentMethodModel{
    let paymentMethod:String
    let imageName:String
    let id:PaymentMethod
}

enum PaymentMethod:String{
    case creditCart
    case applePay
    case payPal
    case cash
}
