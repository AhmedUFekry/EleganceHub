//
//  MockCategoryService.swift
//  EleganceHubTests
//
//  Created by raneem on 21/06/2024.
//

import Foundation
@testable import EleganceHub

class MockCategoryService{
    var shouldReturnError : Bool
    
    init(shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }

    let fakeProductResponse: [String: Any] = [
        "products": [
            [
                "id": 1,"title": "Product 1","body_html": "<p>Description of Product 1</p>","vendor": "Vendor 1","product_type": "Type 1","handle": "product-1","status": "active", "published_scope": "web",
                "tags": "tag1, tag2",
                "variants": [
                    [
                        "id": 1,
                        "product_id": 1,
                        "title": "Variant 1",
                        "price": "19.99",
                        "sku": "SKU1",
                        "position": 1,
                        "weight": 500,
                        "inventory_quantity": 100
                    ],
                    [
                        "id": 2,
                        "product_id": 1,
                        "title": "Variant 2",
                        "price": "29.99",
                        "sku": "SKU2",
                        "position": 2,
                        "weight": 600,
                        "inventory_quantity": 50
                    ]
                ],
                "images": [
                    [
                        "id": 1,
                        "product_id": 1,
                        "position": 1,
                        "width": 1000,
                        "height": 1000,
                        "src": "https://example.com/image1.png"
                    ],
                    [
                        "id": 2,
                        "product_id": 1,
                        "position": 2,
                        "width": 800,
                        "height": 800,
                        "src": "https://example.com/image2.png"
                    ]
                ],
                "image": [
                    "id": 1,
                    "product_id": 1,
                    "position": 1,
                    "width": 1000,
                    "height": 1000,
                    "src": "https://example.com/image1.png"
                ]
            ],
            [
                "id": 2,
                "title": "Product 2",
                "body_html": "<p>Description of Product 2</p>",
                "vendor": "Vendor 2",
                "product_type": "Type 2",
                "handle": "product-2",
                "status": "active",
                "published_scope": "web",
                "tags": "tag3, tag4",
                "variants": [
                    [
                        "id": 3,
                        "product_id": 2,
                        "title": "Variant 3",
                        "price": "39.99",
                        "sku": "SKU3",
                        "position": 1,
                        "weight": 700,
                        "inventory_quantity": 200
                    ]
                ],
                "images": [
                    [
                        "id": 3,
                        "product_id": 2,
                        "position": 1,
                        "width": 1200,
                        "height": 1200,
                        "src": "https://example.com/image3.png"
                    ]
                ],
                "image": [
                    "id": 3,
                    "product_id": 2,
                    "position": 1,
                    "width": 1200,
                    "height": 1200,
                    "src": "https://example.com/image3.png"
                ]
            ]
        ],
        "product": [
            "id": 1,
            "title": "Product 1",
            "body_html": "<p>Description of Product 1</p>",
            "vendor": "Vendor 1",
            "product_type": "Type 1",
            "handle": "product-1",
            "status": "active",
            "published_scope": "web",
            "tags": "tag1, tag2",
            "variants": [
                [
                    "id": 1,
                    "product_id": 1,
                    "title": "Variant 1",
                    "price": "19.99",
                    "sku": "SKU1",
                    "position": 1,
                    "weight": 500,
                    "inventory_quantity": 100
                ],
                [
                    "id": 2,
                    "product_id": 1,
                    "title": "Variant 2",
                    "price": "29.99",
                    "sku": "SKU2",
                    "position": 2,
                    "weight": 600,
                    "inventory_quantity": 50
                ]
            ],
            "images": [
                [
                    "id": 1,
                    "product_id": 1,
                    "position": 1,
                    "width": 1000,
                    "height": 1000,
                    "src": "https://example.com/image1.png"
                ],
                [
                    "id": 2,
                    "product_id": 1,
                    "position": 2,
                    "width": 800,
                    "height": 800,
                    "src": "https://example.com/image2.png"
                ]
            ],
            "image": [
                "id": 1,
                "product_id": 1,
                "position": 1,
                "width": 1000,
                "height": 1000,
                "src": "https://example.com/image1.png"
            ]
        ]
    ]

    
    enum ResponseWithError : Error {
        case responseError
    }
    
}
extension MockCategoryService{
    
    func getCategoryProducts(collectionId: String, completionHandler: @escaping (ProductResponse?, Error?) -> Void)  {
        var result: ProductResponse?
        do {
            let productData = try JSONSerialization.data(withJSONObject: fakeProductResponse, options: .prettyPrinted)
            result = try JSONDecoder().decode(ProductResponse.self, from: productData)
        } catch let error {
            print(error.localizedDescription)
        }

        // shouldReturnError -> true -> error
        // shouldReturnError -> false -> result
        let shouldReturnError = false // Set this based on your test conditions
        if shouldReturnError {
            completionHandler(nil, ResponseWithError.responseError)
        } else {
            completionHandler(result, nil)
        }
    }
}
