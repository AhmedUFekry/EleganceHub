//
//  ProductsDetailsViewModel.swift
//  EleganceHubTests
//
//  Created by raneem on 20/06/2024.
//

import XCTest
@testable import EleganceHub

final class ProductsDetailsViewModelTest: XCTestCase {
    
    var ProdcutsDetails:ProductDetailViewModel?
    
    override func setUpWithError() throws {
        ProdcutsDetails = ProductDetailViewModel(networkManager: ProductDetailNetworkService())
    }

    override func tearDownWithError() throws {
        ProdcutsDetails = nil
    }

    func testGetCategories(){
        let expectation = expectation(description: "Waiting for the API Data")
        ProdcutsDetails?.getProductDetails(productId: 9425665786131)
        ProdcutsDetails?.bindingProduct = { [weak self] in
            XCTAssertNotNil(self?.ProdcutsDetails?.observableProduct)
            expectation.fulfill()
            
        }
        waitForExpectations(timeout: 10)
    }

}
