//
//  CurrencyResponse.swift
//  EleganceHub
//
//  Created by raneem on 15/06/2024.
//

import Foundation
 
struct CurrencyModel: Codable {
    let result: String
    let documentation: String
    let termsOfUse: String
    let timeLastUpdateUnix: Int
    let timeLastUpdateUTC: String
    let timeNextUpdateUnix: Int
    let timeNextUpdateUTC: String
    let baseCode: String
    let conversionRates: [String: Double]
 
    enum CodingKeys: String, CodingKey {
        case result
        case documentation
        case termsOfUse = "terms_of_use"
        case timeLastUpdateUnix = "time_last_update_unix"
        case timeLastUpdateUTC = "time_last_update_utc"
        case timeNextUpdateUnix = "time_next_update_unix"
        case timeNextUpdateUTC = "time_next_update_utc"
        case baseCode = "base_code"
        case conversionRates = "conversion_rates"
    }
}


 
 
func getPrice( completion: @escaping (Double) -> Void) {

    let userCurrency = UserDefaultsHelper.shared.getCurrencyFromUserDefaults()
    let coin: String
 
    switch userCurrency {
    case "EGP":
        coin = "EGP"
    case "USD":
        coin = "USD"
    case "EUR":
        coin = "EUR"
    default:
        completion(1.0)
        return
    }
 
    CurrencyService.fetchConversionRate(coinStr: coin) {
    rateRes in
       guard let rate = rateRes else {
           completion(0.0)
    return
 
}
        completion(rateRes!)
    }
    completion(0.0)
}

func convertPrice(price: String , rate : Double) -> Double{
    
     guard let priceD = Double(price) else {
         return 1.0
     }
    let convertedPrice = priceD * rate
    return convertedPrice
}
