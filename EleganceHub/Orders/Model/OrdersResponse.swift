//
//  OrdersResponse.swift
//  EleganceHub
//
//  Created by raneem on 08/06/2024.
//

import Foundation

import Foundation

struct OrderResponse: Codable {
    let orders: [Order]?
}

struct Order: Codable {
    let id: Int?
    let adminGraphqlApiId: String?
    let appId: Int?
    let browserIp: String?
    let buyerAcceptsMarketing: Bool?
    let cancelReason: String?
    let cancelledAt: String?
    let cartToken: String?
    let checkoutId: String?
    let checkoutToken: String?
    let clientDetails: String?
    let closedAt: String?
    let company: String?
    let confirmationNumber: String?
    let confirmed: Bool?
    let contactEmail: String?
    let createdAt: String?
    let currency: String?
    let currentSubtotalPrice: String?
    let currentSubtotalPriceSet: PriceSet?
    let currentTotalAdditionalFeesSet: String?
    let currentTotalDiscounts: String?
    let currentTotalDiscountsSet: PriceSet?
    let currentTotalDutiesSet: String?
    let currentTotalPrice: String?
    let currentTotalPriceSet: PriceSet?
    let currentTotalTax: String?
    let currentTotalTaxSet: PriceSet?
    let customerLocale: String?
    let deviceId: String?
    let discountCodes: [String]?
    let email: String?
    let estimatedTaxes: Bool?
    let financialStatus: String?
    let fulfillmentStatus: String?
    let landingSite: String?
    let landingSiteRef: String?
    let locationId: String?
    let merchantOfRecordAppId: String?
    let name: String?
    let note: String?
    let noteAttributes: [String]?
    let number: Int?
    let orderNumber: Int?
    let orderStatusUrl: String?
    let originalTotalAdditionalFeesSet: String?
    let originalTotalDutiesSet: String?
    let paymentGatewayNames: [String]?
    let phone: String?
    let poNumber: String?
    let presentmentCurrency: String?
    let processedAt: String?
    let reference: String?
    let referringSite: String?
    let sourceIdentifier: String?
    let sourceName: String?
    let sourceUrl: String?
    let subtotalPrice: String?
    let subtotalPriceSet: PriceSet?
    let tags: String?
    let taxExempt: Bool?
    let taxLines: [TaxLine]?
    let taxesIncluded: Bool?
    let test: Bool?
    let token: String?
    let totalDiscounts: String?
    let totalDiscountsSet: PriceSet?
    let totalLineItemsPrice: String?
    let totalLineItemsPriceSet: PriceSet?
    let totalOutstanding: String?
    let totalPrice: String?
    let totalPriceSet: PriceSet?
    let totalShippingPriceSet: PriceSet?
    let totalTax: String?
    let totalTaxSet: PriceSet?
    let totalTipReceived: String?
    let totalWeight: Int?
    let updatedAt: String?
    let userId: String?
    let billingAddress: ShippingAddress?
    let customer: CustomerForOrders?
    let discountApplications: [String]?
    let fulfillments: [String]?
   // let lineItems: [LineItem]?
    let paymentTerms: String?
    let refunds: [String]?
    let shippingAddress: ShippingAddress?
    let shippingLines: [String]?
}

struct PriceSet: Codable {
    let shopMoney: Money?
    let presentmentMoney: Money?
}
//
//struct Money: Codable {
//    let amount: String?
//    let currencyCode: String?
//}

struct TaxLine: Codable {
    let price: String?
    let rate: Double?
    let title: String?
    let priceSet: PriceSet?
    let channelLiable: Bool?
}

struct CustomerForOrders: Codable {
    let id: Int?
    let email: String?
    let createdAt: String?
    let updatedAt: String?
    let firstName: String?
    let lastName: String?
    let state: String?
    let note: String?
    let verifiedEmail: Bool?
    let multipassIdentifier: String?
    let taxExempt: Bool?
    let phone: String?
    let emailMarketingConsent: EmailMarketingConsentForOrders?
    let smsMarketingConsent: SmsMarketingConsent?
    let tags: String?
    let currency: String?
    let taxExemptions: [String]?
    let adminGraphqlApiId: String?
}

struct EmailMarketingConsentForOrders: Codable {
    let state: String?
    let optInLevel: String?
    let consentUpdatedAt: String?
}

struct SmsMarketingConsent: Codable {
    let state: String?
    let optInLevel: String?
    let consentUpdatedAt: String?
}

//struct LineItem: Codable {
//    let id: Int?
//    let adminGraphqlApiId: String?
//    let attributedStaffs: [String]?
//    let currentQuantity: Int?
//    let fulfillableQuantity: Int?
//    let fulfillmentService: String?
//    let fulfillmentStatus: String?
//    let giftCard: Bool?
//    let grams: Int?
//    let name: String?
//    let price: String?
//    let priceSet: PriceSet?
//    let productExists: Bool?
//    let productId: Int?

//    let properties: [String]?
//    let quantity: Int?
//    let requiresShipping: Bool?
//    let sku: String?
//    let taxable: Bool?
//    let title: String?
//    let totalDiscount: String?
//    let totalDiscountSet: PriceSet?
//    let variantId: Int?  // Changed from String? to Int?
//    let variantInventoryManagement: String?
//    let variantTitle: String?
//    let vendor: String?
//    let taxLines: [TaxLine]?
//    let duties: [String]?
//    let discountAllocations: [String]?
//}

struct ShippingAddress: Codable {
    let firstName: String?
    let lastName: String?
    let address1: String?
    let address2: String?
    let city: String?
    let province: String?
    let country: String?
    let zip: String?
    let phone: String?
    let name: String?
    let countryCode: String?
    let provinceCode: String?
}
