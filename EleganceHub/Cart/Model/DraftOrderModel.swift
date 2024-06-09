//
//  OrderModel.swift
//  EleganceHub
//
//  Created by AYA on 25/05/2024.
//


import Foundation

// MARK: - PostDraftOrderResponse
struct PostDraftOrderResponse: Codable {
    let draftOrders: DraftOrder?

    enum CodingKeys: String, CodingKey {
        case draftOrders = "draft_order"
    }
}

struct DraftOrdersResponse: Codable {
    let draftOrders: [DraftOrder]?

    enum CodingKeys: String, CodingKey {
        case draftOrders = "draft_orders"
    }
}

// MARK: - DraftOrder
struct DraftOrder: Codable {
    let id: Int?
    let note, email: String?
    let taxesIncluded: Bool?
    let currency: String?
    let invoiceSentAt: String?
    let createdAt, updatedAt: String?
    let taxExempt: Bool?
    let completedAt: String?
    let name, status: String?
    let lineItems: [LineItem]?
    let shippingAddress, billingAddress: Address?
    let invoiceURL: String?
    let appliedDiscount: AppliedDiscount?
    let orderID: Int?
    let shippingLine: ShippingLine?
    let tags: String?
    let totalPrice, subtotalPrice, totalTax: String?
    let adminGraphqlAPIID: String?
    let customer: Customer?

    enum CodingKeys: String, CodingKey {
        case id, note, email
        case taxesIncluded = "taxes_included"
        case currency
        case invoiceSentAt = "invoice_sent_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxExempt = "tax_exempt"
        case completedAt = "completed_at"
        case name, status
        case lineItems = "line_items"
        case shippingAddress = "shipping_address"
        case billingAddress = "billing_address"
        case invoiceURL = "invoice_url"
        case appliedDiscount = "applied_discount"
        case orderID = "order_id"
        case shippingLine = "shipping_line"
        case tags
        case totalPrice = "total_price"
        case subtotalPrice = "subtotal_price"
        case totalTax = "total_tax"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case customer
    }
}

// MARK: - AppliedDiscount
struct AppliedDiscount: Codable {
    let description, value: String?
    let title: String?
    let amount, valueType: String?

    enum CodingKeys: String, CodingKey {
        case description, value, title, amount
        case valueType = "value_type"
    }
}

// MARK: - LineItem
struct LineItem: Codable {
    let id: Int?
    let variantID, productID: Int?
    let title: String?
    let variantTitle: String?
    let productImage: String?
    let vendor: String?
    let quantity: Int?
    let requiresShipping, taxable, giftCard: Bool?
    let fulfillmentService: String?
    let grams: Int?
    let appliedDiscount: Bool?
    let name: String?
    let custom: Bool?
    let price, adminGraphqlAPIID: String?
    let properties: [Property]?

    enum CodingKeys: String, CodingKey {
        case id
        case variantID = "variant_id"
        case productID = "product_id"
        case title
        case variantTitle = "variant_title"
        case productImage = "product_image"
        case vendor, quantity
        case requiresShipping = "requires_shipping"
        case taxable
        case giftCard = "gift_card"
        case fulfillmentService = "fulfillment_service"
        case grams
        case appliedDiscount = "applied_discount"
        case name, custom, price
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case properties
    }
}
// MARK: - Property Of selected Item
struct Property: Codable {
    let name: String?
    let value: String?
}

// MARK: - MarketingConsent
struct MarketingConsent: Codable {
    let state: String?
    let optInLevel: String?
    let consentUpdatedAt: String?

    enum CodingKeys: String, CodingKey {
        case state
        case optInLevel = "opt_in_level"
        case consentUpdatedAt = "consent_updated_at"
    }
}

// MARK: - ShippingLine
struct ShippingLine: Codable {
    let title: String?
    let custom: Bool?
    let handle: String?
    let price: String?
}

// MARK: - Set
struct Set: Codable {
    let shopMoney, presentmentMoney: Money?

    enum CodingKeys: String, CodingKey {
        case shopMoney = "shop_money"
        case presentmentMoney = "presentment_money"
    }
}

// MARK: - Money
struct Money: Codable {
    let amount: String?
    let currencyCode: String?

    enum CodingKeys: String, CodingKey {
        case amount
        case currencyCode = "currency_code"
    }
}
