//
//  DiscountModel.swift
//  EleganceHub
//
//  Created by AYA on 30/05/2024.
//

import Foundation
// MARK: - DiscountModel
struct DiscountModel: Codable {
    let price_rules: [PriceRule]
}

// MARK: - PriceRule
struct PriceRule: Codable {
    let id: Int?
    let value_type, value, customer_selection, target_type: String?
    let target_selection, allocation_method: String?
    let allocation_limit: String?
    let once_per_customer: Bool
    let usage_limit: String?
    let starts_at, ends_at: String?
    let created_at, updated_at: String?
    let entitled_product_ids, entitled_variant_ids, entitled_collection_ids, entitled_country_ids: [String]
    let prerequisite_product_ids, prerequisite_variant_ids, prerequisite_collection_ids, customer_segment_prerequisite_ids: [Int]
    let prerequisite_customer_ids: [Int]
    let prerequisite_subtotal_range, prerequisite_quantity_range, prerequisite_shipping_price_range: String?
    let prerequisite_to_entitlement_quantity_ratio: PrerequisiteToEntitlementQuantityRatio?
    let prerequisite_to_entitlement_purchase: PrerequisiteToEntitlementPurchase?
    let title, admin_graphql_api_id: String?
}

// MARK: - PrerequisiteToEntitlementPurchase
struct PrerequisiteToEntitlementPurchase: Codable {
    let prerequisite_amount: String?
}

// MARK: - PrerequisiteToEntitlementQuantityRatio
struct PrerequisiteToEntitlementQuantityRatio: Codable {
    let prerequisite_quantity, entitled_quantity: Int?
}

// MARK: - DiscountCodesResponse
struct DiscountCodesResponse:Codable{
    let discount_codes:[DiscountCodes]
}

// MARK: - DiscountCodes
struct DiscountCodes:Codable{
    let code,created_at,updated_at: String?
    let usage_count,id,price_rule_id:Int?
}

// MARK: - DiscountCodes
struct CouponCellData{
    let imageName:String?
    let codeName:String?
}

// MARK: - Validation Response
struct ValidationResponse: Codable {
    let discountCode: DiscountCodes?

    enum CodingKeys: String, CodingKey {
        case discountCode = "discount_code"
    }
}

struct PriceRuleResponse: Codable {
    let priceRule: PriceRule?

    enum CodingKeys: String, CodingKey {
        case priceRule = "price_rule"
    }
}

