//
//  CurrencyService.swift
//  EleganceHub
//
//  Created by raneem on 19/06/2024.
//

import Foundation

protocol CurrencyServiceProtocol{
    
    //MARK: Currency
    static func fetchConversionRate(coinStr: String, completion: @escaping (Double?) -> Void)
    
}

class CurrencyService:CurrencyServiceProtocol{
    static func fetchConversionRate(coinStr: String, completion: @escaping (Double?) -> Void) {
        let currencyType = "USD"
        let urlStr = "https://v6.exchangerate-api.com/v6/\(Constants.currencyApiKey)/latest/\(currencyType)"
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

}
