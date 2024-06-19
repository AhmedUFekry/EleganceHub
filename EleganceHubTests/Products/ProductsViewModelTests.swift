//
//  ProductsViewModelTests.swift
//  EleganceHubTests
//
//  Created by raneem on 20/06/2024.
//

import XCTest
@testable import EleganceHub

final class ProductsViewModelTests: XCTestCase {
    var productsViewModel:ProductsViewModel!
    
    override func setUpWithError() throws {
        productsViewModel = ProductsViewModel()
    }

    override func tearDownWithError() throws {
       productsViewModel = nil
   }
    
    
    func testGetOrders(){
        
        let expectation = expectation(description: "Waiting for the API Data")
        productsViewModel?.getProductsFromModel(collectionId: 333  )
        productsViewModel.bindResultToViewController = { [weak self] in
            XCTAssertNotNil(self?.productsViewModel?.vmResult)
            XCTAssertNotNil(self?.productsViewModel.vmResult?.count, "ViewModel result should contain orders")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
}
