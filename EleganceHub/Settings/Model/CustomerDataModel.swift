//
//  CustomerDataModel.swift
//  EleganceHub
//
//  Created by AYA on 05/06/2024.
//

import Foundation

// MARK: - CustomerResponse
struct CustomerResponse: Codable {
    let customer: Customer?
}

// MARK: - Customer
struct Customer: Codable {
    let email, firstName, note, lastName: String?
    let id: Int?
    let createdAt, updatedAt: String?
    let ordersCount: Int?
    let state, totalSpent: String?
    let lastOrderID: Int?
    let verifiedEmail: Bool?
    let multipassIdentifier: String?
    let taxExempt: Bool?
    let tags: String?
    let lastOrderName: String?
    let currency: String?
    let phone: String?
    let addresses: [Address]?
    let taxExemptions: [String]?
    let emailMarketingConsent: EmailMarketingConsent?
   // let smsMarketingConsent: String?
    let adminGraphqlAPIID: String?
    let defaultAddress: Address?

    enum CodingKeys: String, CodingKey {
        case email
        case firstName = "first_name"
        case note
        case lastName = "last_name"
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case ordersCount = "orders_count"
        case state
        case totalSpent = "total_spent"
        case lastOrderID = "last_order_id"
        case verifiedEmail = "verified_email"
        case multipassIdentifier = "multipass_identifier"
        case taxExempt = "tax_exempt"
        case tags
        case lastOrderName = "last_order_name"
        case currency, phone, addresses
        case taxExemptions = "tax_exemptions"
        case emailMarketingConsent = "email_marketing_consent"
        //case smsMarketingConsent = "sms_marketing_consent"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case defaultAddress = "default_address"
    }
}


// MARK: - EmailMarketingConsent
struct EmailMarketingConsent: Codable {
    let state, optInLevel: String?
    let consentUpdatedAt: String?

    enum CodingKeys: String, CodingKey {
        case state
        case optInLevel = "opt_in_level"
        case consentUpdatedAt = "consent_updated_at"
    }
}


