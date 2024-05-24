//
//  SmartCollections.swift
//  EleganceHub
//
//  Created by raneem on 24/05/2024.
//
import Foundation

// MARK: - SmartCollections
struct SmartCollections: Codable {
    let smartCollections: [SmartCollection]
    
    enum CodingKeys: String, CodingKey {
        case smartCollections = "smart_collections"
    }
}

// MARK: - SmartCollection
struct SmartCollection: Codable {
    let id: Int
    let handle, title: String
    let updatedAt, bodyHTML, publishedAt: String
    let sortOrder: String
    let templateSuffix: String?
    let disjunctive: Bool
    let rules: [Rule]
    let publishedScope, adminGraphqlAPIID: String
    let image: productImage
    
    enum CodingKeys: String, CodingKey {
        case id, handle, title
        case updatedAt = "updated_at"
        case bodyHTML = "body_html"
        case publishedAt = "published_at"
        case sortOrder = "sort_order"
        case templateSuffix = "template_suffix"
        case disjunctive
        case rules
        case publishedScope = "published_scope"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case image
    }
}

// MARK: - Image
struct Image: Codable {
    let createdAt: String
    let alt: String?
    let width, height: Int
    let src: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case alt, width, height, src
    }
}

// MARK: - Rule
struct Rule: Codable {
    let column, relation, condition: String
}
