//
//  OrdersResponse.swift
//  EleganceHub
//
//  Created by raneem on 08/06/2024.
//

import Foundation

struct OrderResponse: Codable {
    let orders: [Order]?
}

struct PostOrdersModel: Codable {
    let order: Order
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
    let checkoutId: Int?
    let checkoutToken: String?
    let clientDetails: ClientDetails?
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
    let discountCodes: [DiscountCode]?
    let email: String?
    let estimatedTaxes: Bool?
    let financialStatus: String?
    let fulfillmentStatus: String?
    let landingSite: String?
    let landingSiteRef: String?
    let locationId: Int?
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
    let discountApplications: [DiscountApplication]?
    let fulfillments: [String]?
    let lineItems: [LineItemOrder]?
    let paymentTerms: String?
    let refunds: [String]?
    let shippingAddress: ShippingAddress?
    let shippingLines: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case adminGraphqlApiId = "admin_graphql_api_id"
        case appId = "app_id"
        case browserIp = "browser_ip"
        case buyerAcceptsMarketing = "buyer_accepts_marketing"
        case cancelReason = "cancel_reason"
        case cancelledAt = "cancelled_at"
        case cartToken = "cart_token"
        case checkoutId = "checkout_id"
        case checkoutToken = "checkout_token"
        case clientDetails = "client_details"
        case closedAt = "closed_at"
        case company
        case confirmationNumber = "confirmation_number"
        case confirmed
        case contactEmail = "contact_email"
        case createdAt = "created_at"
        case currency
        case currentSubtotalPrice = "current_subtotal_price"
        case currentSubtotalPriceSet = "current_subtotal_price_set"
        case currentTotalAdditionalFeesSet = "current_total_additional_fees_set"
        case currentTotalDiscounts = "current_total_discounts"
        case currentTotalDiscountsSet = "current_total_discounts_set"
        case currentTotalDutiesSet = "current_total_duties_set"
        case currentTotalPrice = "current_total_price"
        case currentTotalPriceSet = "current_total_price_set"
        case currentTotalTax = "current_total_tax"
        case currentTotalTaxSet = "current_total_tax_set"
        case customerLocale = "customer_locale"
        case deviceId = "device_id"
        case discountCodes = "discount_codes"
        case email
        case estimatedTaxes = "estimated_taxes"
        case financialStatus = "financial_status"
        case fulfillmentStatus = "fulfillment_status"
        case landingSite = "landing_site"
        case landingSiteRef = "landing_site_ref"
        case locationId = "location_id"
        case merchantOfRecordAppId = "merchant_of_record_app_id"
        case name
        case note
        case noteAttributes = "note_attributes"
        case number
        case orderNumber = "order_number"
        case orderStatusUrl = "order_status_url"
        case originalTotalAdditionalFeesSet = "original_total_additional_fees_set"
        case originalTotalDutiesSet = "original_total_duties_set"
        case paymentGatewayNames = "payment_gateway_names"
        case phone
        case poNumber = "po_number"
        case presentmentCurrency = "presentment_currency"
        case processedAt = "processed_at"
        case reference
        case referringSite = "referring_site"
        case sourceIdentifier = "source_identifier"
        case sourceName = "source_name"
        case sourceUrl = "source_url"
        case subtotalPrice = "subtotal_price"
        case subtotalPriceSet = "subtotal_price_set"
        case tags
        case taxExempt = "tax_exempt"
        case taxLines = "tax_lines"
        case taxesIncluded = "taxes_included"
        case test
        case token
        case totalDiscounts = "total_discounts"
        case totalDiscountsSet = "total_discounts_set"
        case totalLineItemsPrice = "total_line_items_price"
        case totalLineItemsPriceSet = "total_line_items_price_set"
        case totalOutstanding = "total_outstanding"
        case totalPrice = "total_price"
        case totalPriceSet = "total_price_set"
        case totalShippingPriceSet = "total_shipping_price_set"
        case totalTax = "total_tax"
        case totalTaxSet = "total_tax_set"
        case totalTipReceived = "total_tip_received"
        case totalWeight = "total_weight"
        case updatedAt = "updated_at"
        case userId = "user_id"
        case billingAddress = "billing_address"
        case customer
        case discountApplications = "discount_applications"
        case fulfillments
        case lineItems = "line_items"
        case paymentTerms = "payment_terms"
        case refunds
        case shippingAddress = "shipping_address"
        case shippingLines = "shipping_lines"
    }
}

struct ClientDetails: Codable {
    let acceptLanguage: String?
    let browserHeight: Int?
    let browserIp: String?
    let browserWidth: Int?
    let sessionHash: String?
    let userAgent: String?

    enum CodingKeys: String, CodingKey {
        case acceptLanguage = "accept_language"
        case browserHeight = "browser_height"
        case browserIp = "browser_ip"
        case browserWidth = "browser_width"
        case sessionHash = "session_hash"
        case userAgent = "user_agent"
    }
}

struct PriceSet: Codable {
    let shopMoney: MoneyOrder?
    let presentmentMoney: MoneyOrder?

    enum CodingKeys: String, CodingKey {
        case shopMoney = "shop_money"
        case presentmentMoney = "presentment_money"
    }
}

struct MoneyOrder: Codable {
    let amount: String?
    let currencyCode: String?

    enum CodingKeys: String, CodingKey {
        case amount
        case currencyCode = "currency_code"
    }
}

struct TaxLine: Codable {
    let price: String?
    let rate: Double?
    let title: String?
    let priceSet: PriceSet?
    let channelLiable: Bool?

    enum CodingKeys: String, CodingKey {
        case price
        case rate
        case title
        case priceSet = "price_set"
        case channelLiable = "channel_liable"
    }
}

struct DiscountCode: Codable {
    let code: String?
    let amount: String?
    let type: String?
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
    let addresses: [CustomerAddressForOrders]?
    let acceptsMarketing: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case state
        case note
        case verifiedEmail = "verified_email"
        case multipassIdentifier = "multipass_identifier"
        case taxExempt = "tax_exempt"
        case phone
        case emailMarketingConsent = "email_marketing_consent"
        case smsMarketingConsent = "sms_marketing_consent"
        case tags
        case currency
        case addresses
        case acceptsMarketing = "accepts_marketing"
    }
}

struct CustomerAddressForOrders: Codable {
    let id: Int?
    let customerId: Int?
    let firstName: String?
    let lastName: String?
    let company: String?
    let address1: String?
    let address2: String?
    let city: String?
    let province: String?
    let country: String?
    let zip: String?
    let phone: String?
    let name: String?
    let provinceCode: String?
    let countryCode: String?
    let countryName: String?
    let defaultAddress: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case customerId = "customer_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case company
        case address1 = "address1"
        case address2 = "address2"
        case city
        case province
        case country
        case zip
        case phone
        case name
        case provinceCode = "province_code"
        case countryCode = "country_code"
        case countryName = "country_name"
        case defaultAddress = "default_address"
    }
}

struct EmailMarketingConsentForOrders: Codable {
    let state: String?
    let optInLevel: String?
    let consentUpdatedAt: String?

    enum CodingKeys: String, CodingKey {
        case state
        case optInLevel = "opt_in_level"
        case consentUpdatedAt = "consent_updated_at"
    }
}

struct SmsMarketingConsent: Codable {
    let state: String?
    let optInLevel: String?
    let consentUpdatedAt: String?
    let consentCollectedFrom: String?

    enum CodingKeys: String, CodingKey {
        case state
        case optInLevel = "opt_in_level"
        case consentUpdatedAt = "consent_updated_at"
        case consentCollectedFrom = "consent_collected_from"
    }
}

struct ShippingAddress: Codable {
    let firstName: String?
    let address1: String?
    let phone: String?
    let city: String?
    let zip: String?
    let province: String?
    let country: String?
    let lastName: String?
    let address2: String?
    let company: String?
    let latitude: Double?
    let longitude: Double?
    let name: String?
    let countryCode: String?
    let provinceCode: String?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case address1
        case phone
        case city
        case zip
        case province
        case country
        case lastName = "last_name"
        case address2
        case company
        case latitude
        case longitude
        case name
        case countryCode = "country_code"
        case provinceCode = "province_code"
    }
}

struct DiscountApplication: Codable {
    let targetType: String?
    let type: String?
    let value: String?
    let valueType: String?
    let allocationMethod: String?
    let targetSelection: String?
    let description: String?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case targetType = "target_type"
        case type
        case value
        case valueType = "value_type"
        case allocationMethod = "allocation_method"
        case targetSelection = "target_selection"
        case description
        case title
    }
}

struct LineItemOrder: Codable {
    let id: Int?
    let adminGraphqlApiId: String?
    let fulfillableQuantity: Int?
    let fulfillmentService: String?
    let fulfillmentStatus: String?
    let giftCard: Bool?
    let grams: Int?
    let name: String?
    let price: String?
    let priceSet: PriceSet?
    let productExists: Bool?
    let productId: Int?
    let properties: [LineItemProperty]?
    let quantity: Int?
    let requiresShipping: Bool?
    let sku: String?
    let taxLines: [TaxLine]?
    let taxable: Bool?
    let title: String?
    let totalDiscount: String?
    let totalDiscountSet: PriceSet?
    let variantId: Int?
    let variantInventoryManagement: String?
    let variantTitle: String?
    let vendor: String?

    enum CodingKeys: String, CodingKey {
        case id
        case adminGraphqlApiId = "admin_graphql_api_id"
        case fulfillableQuantity = "fulfillable_quantity"
        case fulfillmentService = "fulfillment_service"
        case fulfillmentStatus = "fulfillment_status"
        case giftCard = "gift_card"
        case grams
        case name
        case price
        case priceSet = "price_set"
        case productExists = "product_exists"
        case productId = "product_id"
        case properties
        case quantity
        case requiresShipping = "requires_shipping"
        case sku
        case taxLines = "tax_lines"
        case taxable
        case title
        case totalDiscount = "total_discount"
        case totalDiscountSet = "total_discount_set"
        case variantId = "variant_id"
        case variantInventoryManagement = "variant_inventory_management"
        case variantTitle = "variant_title"
        case vendor
    }
}

struct LineItemProperty: Codable {
    let name: String?
    let value: String?
}

