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
    let option1: String?
    let option2: String?
    let option3: String?
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
        case productId = "product_id"
        case inventoryPolicy = "inventory_policy"
        case compareAtPrice = "compare_at_price"
        case fulfillmentService = "fulfillment_service"
        case inventoryManagement = "inventory_management"
        case option1, option2, option3
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.productId = try container.decode(Int.self, forKey: .productId)
        self.title = try container.decode(String.self, forKey: .title)
        self.price = try container.decode(String.self, forKey: .price)
        self.sku = try container.decode(String.self, forKey: .sku)
        self.position = try container.decode(Int.self, forKey: .position)
        self.inventoryPolicy = try container.decode(String.self, forKey: .inventoryPolicy)
        self.compareAtPrice = try container.decodeIfPresent(String.self, forKey: .compareAtPrice)
        self.fulfillmentService = try container.decode(String.self, forKey: .fulfillmentService)
        self.inventoryManagement = try container.decode(String.self, forKey: .inventoryManagement)
        self.option1 = try container.decodeIfPresent(String.self, forKey: .option1)
        self.option2 = try container.decodeIfPresent(String.self, forKey: .option2)
        self.option3 = try container.decodeIfPresent(String.self, forKey: .option3)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
        self.taxable = try container.decode(Bool.self, forKey: .taxable)
        self.barcode = try container.decodeIfPresent(String.self, forKey: .barcode)
        self.grams = try container.decode(Int.self, forKey: .grams)
        self.weight = try container.decode(Double.self, forKey: .weight)
        self.weightUnit = try container.decode(String.self, forKey: .weightUnit)
        self.inventoryItemId = try container.decode(Int.self, forKey: .inventoryItemId)
        self.inventoryQuantity = try container.decode(Int.self, forKey: .inventoryQuantity)
        self.oldInventoryQuantity = try container.decode(Int.self, forKey: .oldInventoryQuantity)
        self.requiresShipping = try container.decode(Bool.self, forKey: .requiresShipping)
        self.adminGraphqlApiId = try container.decode(String.self, forKey: .adminGraphqlApiId)
        self.imageId = try container.decodeIfPresent(String.self, forKey: .imageId)
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
