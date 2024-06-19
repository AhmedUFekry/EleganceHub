//
//  HomeNetworkTest.swift
//  EleganceHubTests
//
//  Created by AYA on 19/06/2024.
//

import XCTest
@testable import EleganceHub

final class HomeNetworkTest:XCTestCase{
    
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
    func testGetPriceRulesSuccess(){
        let expectation = self.expectation(description: "Fetch AllPrice rule succeeds")
        
        NetworkCall.getPriceRules { result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response.price_rules)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, got failure")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetDiscountCodesSuccess(){
        let expectation = self.expectation(description: "Fetch All Discount succeeds")
        let id = 1467312931091
        
        NetworkCall.getDiscountCodes(discountId: id){ result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response.discount_codes)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, got failure")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
