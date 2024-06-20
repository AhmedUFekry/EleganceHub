//
//  CartNetworkServiceTest.swift
//  EleganceHubTests
//
//  Created by AYA on 19/06/2024.
//

import XCTest
@testable import EleganceHub

final class CartNetworkServiceTest:XCTestCase{
    let customerID = 8229959500051
    let orderID = 1157420974355
    
    var networkService:CartNetworkServiceProtocol?
    
    override func setUpWithError() throws {
        networkService = CartNetworkService()
    }
    
    override func tearDownWithError() throws {
        networkService = nil
    }
    
    func testPostItemToCartNewProductSuccess(){
        let expectation = self.expectation(description: "Fetch cities succeeds")
        
        let variant = Variant(id: 2, productID: 1, title: "Test", price: "10", sku: "", position: 0, weight: 0, inventory_quantity: 4)
        
        let productImage = ProductImage(id: 1, productID: 1, position: 0, width: 0, height: 0, src: "t")

        let product = Product(id: 1, title: "test", bodyHTML: "", vendor: "", productType: "", handle: "", status: "", publishedScope: "", tags: "", variants: [variant], images: nil, image: productImage)
        
        networkService?.postItemToCartNewProduct(customerID: customerID, product: product)
            .subscribe(onNext: { response in
                XCTAssertNotNil(response)
                expectation.fulfill()
        },onError: { error in
            XCTFail("Expected success, got failure \(error)")
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetAllDraftOrders(){
        let expectation = self.expectation(description: "Fetch All Draft Orders succeeds")
        networkService?.getAllDraftOrders()
            .subscribe(onNext: { response in
                XCTAssertNotNil(response.draftOrders)
                expectation.fulfill()
        },onError: { error in
            XCTFail("Expected success, got failure \(error)")
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetCustomerOrder(){
        let expectation = self.expectation(description: "Fetch Get Customer Order succeeds")
        networkService?.getCustomerOrder(orderID: orderID, completionHandler: { response in
            switch response {
            case .success(let data):
                XCTAssertNotNil(data)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, got failure \(error)")
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAddNewLineItemToDraftOrderSuccess(){
        let expectation = self.expectation(description: "Post new Line Items succeeds")

        let draftOrder = DraftOrder(id: orderID, note: "", email: "shimaasamy460@gmail.com", taxesIncluded: false, currency: "EGP", invoiceSentAt: nil, createdAt: nil, updatedAt: nil, taxExempt: false, completedAt: nil, name: "#D74", status: "open", lineItems: [LineItem(id: 1, variantID: 49039604580627, productID: 9425660412179, title: "VANS APPAREL AND ACCESSORIES | CLASSIC SUPER NO SHOW SOCKS 3 PACK WHITE", variantTitle: nil, productImage: "", vendor: "", requiresShipping: false, taxable: false, giftCard: false, fulfillmentService: "", grams: 1, appliedDiscount: false, name: "VANS APPAREL AND ACCESSORIES", custom: false)], invoiceURL: "https://mad44-ism-ios1.myshopify.com/88004264211/invoices/c97d37c09892b476b3a8f3baa0674737", orderID: orderID, shippingLine: nil, tags: nil, totalPrice: "29.90", subtotalPrice: "29.90", totalTax: "0.0", adminGraphqlAPIID: nil, customer: Customer(email: "shimaasamy460@gmail.com", firstName: "s", note: nil, lastName: "s", id: self.customerID, createdAt: nil, updatedAt: nil, ordersCount: 1, state: nil, totalSpent: "0.0", lastOrderID: 1, verifiedEmail: false, multipassIdentifier: nil, taxExempt: false, tags: "", lastOrderName: nil, currency: nil, phone: "0.0", addresses: nil, taxExemptions: nil, emailMarketingConsent: nil, adminGraphqlAPIID: nil, defaultAddress: nil))
        
        networkService?.addNewLineItemToDraftOrder(orderID: self.orderID, updatedDraftOrder: draftOrder)
            .subscribe(onNext: { response in
                XCTAssertNotNil(response)
                expectation.fulfill()
            },onError: { error in
                XCTFail("Expected success, got failure \(error)")
            })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetDraftOrderForUser(){
        let expectation = self.expectation(description: "Fetch Get Draft order succeeds")

        networkService?.getDraftOrderForUser(orderID: orderID)
            .subscribe(onNext: { response in
                XCTAssertNotNil(response.draftOrders)
                expectation.fulfill()
            },onError: { error in
                XCTFail("Expected success, got failure \(error)")
            })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCheckForCopunsSuccess(){
        let expectation = self.expectation(description: "Fetch Copuons succeeds")
        let code = "SUMMERSALE10OFF"
        networkService?.checkForCopuns(discountCode: code, completionHandler: { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, got failure \(error)")
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testUpdateDraftOrderSuccess(){
        let expectation = self.expectation(description: "Fetch cities succeeds")

        let draftOrder = DraftOrder(id: orderID, note: "", email: "shimaasamy460@gmail.com", taxesIncluded: false, currency: "EGP", invoiceSentAt: nil, createdAt: nil, updatedAt: nil, taxExempt: false, completedAt: nil, name: "#D74", status: "open", lineItems: [LineItem(id: 1, variantID: 49039604580627, productID: 9425660412179, title: "VANS APPAREL AND ACCESSORIES | CLASSIC SUPER NO SHOW SOCKS 3 PACK WHITE", variantTitle: nil, productImage: "", vendor: "", requiresShipping: false, taxable: false, giftCard: false, fulfillmentService: "", grams: 1, appliedDiscount: false, name: "VANS APPAREL AND ACCESSORIES", custom: false)], invoiceURL: "https://mad44-ism-ios1.myshopify.com/88004264211/invoices/c97d37c09892b476b3a8f3baa0674737", orderID: orderID, shippingLine: nil, tags: nil, totalPrice: "29.90", subtotalPrice: "29.90", totalTax: "0.0", adminGraphqlAPIID: nil, customer: Customer(email: "shimaasamy460@gmail.com", firstName: "s", note: nil, lastName: "s", id: self.customerID, createdAt: nil, updatedAt: nil, ordersCount: 1, state: nil, totalSpent: "0.0", lastOrderID: 1, verifiedEmail: false, multipassIdentifier: nil, taxExempt: false, tags: "", lastOrderName: nil, currency: nil, phone: "0.0", addresses: nil, taxExemptions: nil, emailMarketingConsent: nil, adminGraphqlAPIID: nil, defaultAddress: nil))
        
        networkService?.updateDraftOrder(orderID: self.orderID, draftOrder: draftOrder)
            .subscribe(onNext: { response in
                XCTAssertNotNil(response)
                expectation.fulfill()
            },onError: { error in
                XCTFail("Expected success, got failure \(error)")
            })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetPriceRule(){
        let expectation = self.expectation(description: "Fetch cities succeeds")
        let code = 1467312931091
        networkService?.getPriceRule(priceRuleID: code, completionHandler: { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, got failure \(error)")
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDeleteDraftOrderSuccess(){
        let expectation = self.expectation(description: "Fetch Delete Draft Order succeeds")
        networkService?.deleteDraftOrder(orderID: 1 )
            .subscribe(onNext: { response in
                XCTAssertTrue(response)
                expectation.fulfill()
        },onError: { error in
            XCTFail("Expected success, got failure")

        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
