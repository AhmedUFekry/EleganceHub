//
//  AddressDataModel.swift
//  EleganceHub
//
//  Created by AYA on 02/06/2024.
//

import Foundation

// MARK: - AddressDataModel
struct AddressDataModel: Codable {
    let addresses: [Address]?
}


// MARK: - Address
struct Address: Codable {
    let id, customerID: Int?
    let firstName, lastName, company: String?
    let address1, address2, city, province: String?
    let country, zip, phone, name: String?
    let provinceCode, countryCode, countryName: String?
    let addressDefault: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case company, address1, address2, city, province, country, zip, phone, name
        case provinceCode = "province_code"
        case countryCode = "country_code"
        case countryName = "country_name"
        case addressDefault = "default"
    }
}

struct CountryDataModel{
    let countryCode, countryName, currencyCode, extensionCode, flag :String?
}

struct CitiesResponse:Codable{
    let error : Bool?
    let msg :String?
    let data: [String]?
}

