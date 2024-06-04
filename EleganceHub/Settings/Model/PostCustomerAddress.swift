//
//  PostCustomerAddress.swift
//  EleganceHub
//
//  Created by AYA on 04/06/2024.
//

import Foundation

import Foundation

// MARK: - PostCustomerAddress
struct PostCustomerAddress: Codable {
    let address: AddressData?
}

struct PostAddressResponse: Codable {
    let customerAddress: Address?

    enum CodingKeys: String, CodingKey {
        case customerAddress = "customer_address"
    }
}

// MARK: - Address
struct AddressData: Codable {
    let address1, address2, city, company: String?
    let firstName, lastName, phone, province: String?
    let country, zip, name, provinceCode: String?
    let countryCode, countryName: String?

    enum CodingKeys: String, CodingKey {
        case address1, address2, city, company
        case firstName = "first_name"
        case lastName = "last_name"
        case phone, province, country, zip, name
        case provinceCode = "province_code"
        case countryCode = "country_code"
        case countryName = "country_name"
    }
}
