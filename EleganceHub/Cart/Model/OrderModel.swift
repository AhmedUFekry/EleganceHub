//
//  OrderModel.swift
//  EleganceHub
//
//  Created by AYA on 25/05/2024.
//

import Foundation

// MARK: - OrderResponse
struct OrderResponse: Codable {
    let order: Order
}

// MARK: - Order
struct Order: Codable {
    let id: Int
    let adminGraphqlAPIID: String
    let appID: Int
    let browserIP: JSONNull?
    let buyerAcceptsMarketing: Bool
    let cancelReason, cancelledAt, cartToken, checkoutID: JSONNull?
    let checkoutToken, clientDetails, closedAt, company: JSONNull?
    let confirmationNumber: String
    let confirmed: Bool
    let contactEmail: JSONNull?
    let createdAt: Date
    let currency: Currency
    let currentSubtotalPrice: String
    let currentSubtotalPriceSet: Set
    let currentTotalAdditionalFeesSet: JSONNull?
    let currentTotalDiscounts: String
    let currentTotalDiscountsSet: Set
    let currentTotalDutiesSet: JSONNull?
    let currentTotalPrice: String
    let currentTotalPriceSet: Set
    let currentTotalTax: String
    let currentTotalTaxSet: Set
    let customerLocale, deviceID: JSONNull?
    let discountCodes: [JSONAny]
    let email: String
    let estimatedTaxes: Bool
    let financialStatus: String
    let fulfillmentStatus, landingSite, landingSiteRef, locationID: JSONNull?
    let merchantOfRecordAppID: JSONNull?
    let name: String
    let note: JSONNull?
    let noteAttributes: [JSONAny]
    let number, orderNumber: Int
    let orderStatusURL: String
    let originalTotalAdditionalFeesSet, originalTotalDutiesSet: JSONNull?
    let paymentGatewayNames: [String]
    let phone, poNumber: JSONNull?
    let presentmentCurrency: Currency
    let processedAt: Date
    let reference, referringSite, sourceIdentifier: JSONNull?
    let sourceName: String
    let sourceURL: JSONNull?
    let subtotalPrice: String
    let subtotalPriceSet: Set
    let tags: String
    let taxExempt: Bool
    let taxLines: [TaxLine]
    let taxesIncluded, test: Bool
    let token, totalDiscounts: String
    let totalDiscountsSet: Set
    let totalLineItemsPrice: String
    let totalLineItemsPriceSet: Set
    let totalOutstanding, totalPrice: String
    let totalPriceSet, totalShippingPriceSet: Set
    let totalTax: String
    let totalTaxSet: Set
    let totalTipReceived: String
    let totalWeight: Int
    let updatedAt: Date
    let userID, billingAddress, customer: JSONNull?
    let discountApplications, fulfillments: [JSONAny]
    let lineItems: [LineItem]
    let paymentTerms: JSONNull?
    let refunds: [JSONAny]
    let shippingAddress: JSONNull?
    let shippingLines: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case id
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case appID = "app_id"
        case browserIP = "browser_ip"
        case buyerAcceptsMarketing = "buyer_accepts_marketing"
        case cancelReason = "cancel_reason"
        case cancelledAt = "cancelled_at"
        case cartToken = "cart_token"
        case checkoutID = "checkout_id"
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
        case deviceID = "device_id"
        case discountCodes = "discount_codes"
        case email
        case estimatedTaxes = "estimated_taxes"
        case financialStatus = "financial_status"
        case fulfillmentStatus = "fulfillment_status"
        case landingSite = "landing_site"
        case landingSiteRef = "landing_site_ref"
        case locationID = "location_id"
        case merchantOfRecordAppID = "merchant_of_record_app_id"
        case name, note
        case noteAttributes = "note_attributes"
        case number
        case orderNumber = "order_number"
        case orderStatusURL = "order_status_url"
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
        case sourceURL = "source_url"
        case subtotalPrice = "subtotal_price"
        case subtotalPriceSet = "subtotal_price_set"
        case tags
        case taxExempt = "tax_exempt"
        case taxLines = "tax_lines"
        case taxesIncluded = "taxes_included"
        case test, token
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
        case userID = "user_id"
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

enum Currency: String, Codable {
    case eur = "EUR"
}

// MARK: - Set
struct Set: Codable {
    let shopMoney, presentmentMoney: Money

    enum CodingKeys: String, CodingKey {
        case shopMoney = "shop_money"
        case presentmentMoney = "presentment_money"
    }
}

// MARK: - Money
struct Money: Codable {
    let amount: String
    let currencyCode: Currency

    enum CodingKeys: String, CodingKey {
        case amount
        case currencyCode = "currency_code"
    }
}

// MARK: - LineItem
struct LineItem: Codable {
    let id: Int
    let adminGraphqlAPIID: String
    let attributedStaffs: [JSONAny]
    let currentQuantity, fulfillableQuantity: Int
    let fulfillmentService: String
    let fulfillmentStatus: JSONNull?
    let giftCard: Bool
    let grams: Int
    let name, price: String
    let priceSet: Set
    let productExists: Bool
    let productID: JSONNull?
    let properties: [JSONAny]
    let quantity: Int
    let requiresShipping: Bool
    let sku: JSONNull?
    let taxable: Bool
    let title, totalDiscount: String
    let totalDiscountSet: Set
    let variantID, variantInventoryManagement, variantTitle, vendor: JSONNull?
    let taxLines: [TaxLine]
    let duties, discountAllocations: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case id
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case attributedStaffs = "attributed_staffs"
        case currentQuantity = "current_quantity"
        case fulfillableQuantity = "fulfillable_quantity"
        case fulfillmentService = "fulfillment_service"
        case fulfillmentStatus = "fulfillment_status"
        case giftCard = "gift_card"
        case grams, name, price
        case priceSet = "price_set"
        case productExists = "product_exists"
        case productID = "product_id"
        case properties, quantity
        case requiresShipping = "requires_shipping"
        case sku, taxable, title
        case totalDiscount = "total_discount"
        case totalDiscountSet = "total_discount_set"
        case variantID = "variant_id"
        case variantInventoryManagement = "variant_inventory_management"
        case variantTitle = "variant_title"
        case vendor
        case taxLines = "tax_lines"
        case duties
        case discountAllocations = "discount_allocations"
    }
}

// MARK: - TaxLine
struct TaxLine: Codable {
    let channelLiable: Bool
    let price: String
    let priceSet: Set
    let rate: Double
    let title: String

    enum CodingKeys: String, CodingKey {
        case channelLiable = "channel_liable"
        case price
        case priceSet = "price_set"
        case rate, title
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
            return nil
    }

    required init?(stringValue: String) {
            key = stringValue
    }

    var intValue: Int? {
            return nil
    }

    var stringValue: String {
            return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                    return value
            }
            if let value = try? container.decode(Int64.self) {
                    return value
            }
            if let value = try? container.decode(Double.self) {
                    return value
            }
            if let value = try? container.decode(String.self) {
                    return value
            }
            if container.decodeNil() {
                    return JSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                    return value
            }
            if let value = try? container.decode(Int64.self) {
                    return value
            }
            if let value = try? container.decode(Double.self) {
                    return value
            }
            if let value = try? container.decode(String.self) {
                    return value
            }
            if let value = try? container.decodeNil() {
                    if value {
                            return JSONNull()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                    return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                    if value {
                            return JSONNull()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                    let value = try decode(from: &container)
                    arr.append(value)
            }
            return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                    let value = try decode(from: &container, forKey: key)
                    dict[key.stringValue] = value
            }
            return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                    if let value = value as? Bool {
                            try container.encode(value)
                    } else if let value = value as? Int64 {
                            try container.encode(value)
                    } else if let value = value as? Double {
                            try container.encode(value)
                    } else if let value = value as? String {
                            try container.encode(value)
                    } else if value is JSONNull {
                            try container.encodeNil()
                    } else if let value = value as? [Any] {
                            var container = container.nestedUnkeyedContainer()
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                    let key = JSONCodingKey(stringValue: key)!
                    if let value = value as? Bool {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? Int64 {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? Double {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? String {
                            try container.encode(value, forKey: key)
                    } else if value is JSONNull {
                            try container.encodeNil(forKey: key)
                    } else if let value = value as? [Any] {
                            var container = container.nestedUnkeyedContainer(forKey: key)
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                    try container.encode(value)
            } else if let value = value as? Int64 {
                    try container.encode(value)
            } else if let value = value as? Double {
                    try container.encode(value)
            } else if let value = value as? String {
                    try container.encode(value)
            } else if value is JSONNull {
                    try container.encodeNil()
            } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
            }
    }

    public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                    self.value = try JSONAny.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                    self.value = try JSONAny.decodeDictionary(from: &container)
            } else {
                    let container = try decoder.singleValueContainer()
                    self.value = try JSONAny.decode(from: container)
            }
    }

    public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                    var container = encoder.unkeyedContainer()
                    try JSONAny.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                    var container = encoder.container(keyedBy: JSONCodingKey.self)
                    try JSONAny.encode(to: &container, dictionary: dict)
            } else {
                    var container = encoder.singleValueContainer()
                    try JSONAny.encode(to: &container, value: self.value)
            }
    }
}

