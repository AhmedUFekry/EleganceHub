//
//  Products.swift
//  EleganceHub
//
//  Created by raneem on 24/05/2024.
//

import Foundation

struct ProductResponse: Codable {
    let products: [Product]
}

struct Product: Codable {
    let id: Int
    let title: String
    let bodyHtml: String
    let vendor: String
    let productType: String
    let createdAt: String
    let handle: String
    let updatedAt: String
    let publishedAt: String
    let templateSuffix: String?
    let publishedScope: String
    let tags: String
    let status: String
    let adminGraphqlApiId: String
    let variants: [Variant]
    let options: [Option]
    let images: [ProductImage]
    let image: ProductImage

    private enum CodingKeys: String, CodingKey {
        case id, title, vendor, tags, status
        case bodyHtml = "body_html"
        case productType = "product_type"
        case createdAt = "created_at"
        case handle, updatedAt = "updated_at"
        case publishedAt = "published_at"
        case templateSuffix = "template_suffix"
        case publishedScope = "published_scope"
        case adminGraphqlApiId = "admin_graphql_api_id"
        case variants, options, images, image
    }
}

struct Variant: Codable {
    let id, productId: Int
    let title: String
    let price: String
    let sku: String
    let position: Int
    let inventoryPolicy: String
    let compareAtPrice: String?
    let fulfillmentService: String
    let inventoryManagement: String
    let option1, option2, option3: String?
    let createdAt, updatedAt: String
    let taxable: Bool
    let barcode: String?
    let grams: Int
    let weight: Double
    let weightUnit: String
    let inventoryItemId, inventoryQuantity, oldInventoryQuantity: Int
    let requiresShipping: Bool
    let adminGraphqlApiId: String
    let imageId: String?

    private enum CodingKeys: String, CodingKey {
        case id, title, price, sku, position
        case inventoryPolicy = "inventory_policy"
        case compareAtPrice = "compare_at_price"
        case fulfillmentService = "fulfillment_service"
        case inventoryManagement = "inventory_management"
        case option1 = "option1"
        case option2 = "option2"
        case option3 = "option3"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxable, barcode, grams, weight
        case weightUnit = "weight_unit"
        case inventoryItemId = "inventory_item_id"
        case inventoryQuantity = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
        case requiresShipping = "requires_shipping"
        case adminGraphqlApiId = "admin_graphql_api_id"
        case imageId = "image_id"
    }
}

struct Option: Codable {
    let id, productId: Int
    let name: String
    let position: Int
    let values: [String]
}

struct ProductImage: Codable {
    let id: Int
    let alt: String?
    let position, productId: Int
    let createdAt, updatedAt: String
    let adminGraphqlApiId: String
    let width, height: Int
    let src: String
    let variantIds: [String]

    private enum CodingKeys: String, CodingKey {
        case id, alt, position
        case productId = "product_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case adminGraphqlApiId = "admin_graphql_api_id"
        case width, height, src
        case variantIds = "variant_ids"
    }
}
