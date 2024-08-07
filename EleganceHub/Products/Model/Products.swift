//
//  Products.swift
//  EleganceHub
//
//  Created by raneem on 24/05/2024.
//

import Foundation

struct ProductResponse: Codable {
    var products: [Product]?
    var product: Product?

    enum CodingKeys: String, CodingKey {
        case products, product
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        products = try? container.decode([Product].self, forKey: .products)
        product = try? container.decode(Product.self, forKey: .product)
    }
}

// MARK: - Product
struct Product: Codable {
    let id: Int?
    let title, bodyHTML, vendor, productType: String?
    let handle: String?
    let status, publishedScope, tags: String?
    let variants: [Variant]?
    let images: [ProductImage]?
    let image: ProductImage?

    enum CodingKeys: String, CodingKey {
        case id, title
        case vendor
        case bodyHTML = "body_html"
        case productType = "product_type"
        case handle
        case status
        case publishedScope = "published_scope"
        case tags
        case variants, images, image
    }
}

// MARK: - Image
struct ProductImage: Codable {
    let id, productID, position: Int?
    let width, height: Int?
    let src: String?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case position
        case width, height, src
    }
}

// MARK: - Option
struct Option: Codable {
    let id, productID: Int?
    let name: String?
    let position: Int?
    let values: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case name, position, values
    }
}

// MARK: - Variant
struct Variant: Codable {
    let id, productID: Int?
    let title, price, sku: String?
    let position: Int?
    let weight: Int?
    let inventory_quantity : Int?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case title, price, sku, position
        case weight
        case inventory_quantity
    }
}
