//
//  CategoryViewModelTests.swift
//  EleganceHubTests
//
//  Created by raneem on 20/06/2024.
//

import XCTest
@testable import EleganceHub

final class CategoryViewModelTests: XCTestCase {
    var categoryViewModel:CategoryViewModel!
    
    override func setUpWithError() throws {
        categoryViewModel = CategoryViewModel()
    }
    
    override func tearDownWithError() throws {
        categoryViewModel = nil
    }
    
    func testGetCategories(){
        let expectation = expectation(description: "Waiting for the API Data")
        categoryViewModel.getCategoryProducts(category: .Women)
        categoryViewModel.bindResultToViewController = { [weak self] in
            XCTAssertNotNil(self?.categoryViewModel?.categoryResult)
            XCTAssertNotNil(self?.categoryViewModel?.categoryResult.count, "ViewModel result should contain orders")
            expectation.fulfill()
            
        }
        waitForExpectations(timeout: 10)
    }
    
    
}
