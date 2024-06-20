//
//  ProductDetailNetworkServiceTest.swift
//  EleganceHubTests
//
//  Created by Shimaa on 20/06/2024.
//

import XCTest
@testable import EleganceHub
import Alamofire


final class ProductDetailNetworkServiceTest: XCTestCase {

    var networkService: DetailNetworkProtocol?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkService = ProductDetailNetworkService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        networkService = nil
    }

    func testGetProductDetailsSuccess() {
        let expectation = self.expectation(description: "fetching product details succeeded")
                let testProductId = 12345
        
                networkService?.getProductDetails(productId: testProductId) { productResponse in
                    XCTAssertNotNil(productResponse, "product response should not be nil")
                    expectation.fulfill()
            }
            
            waitForExpectations(timeout: 10, handler: nil)
        }
        
}
