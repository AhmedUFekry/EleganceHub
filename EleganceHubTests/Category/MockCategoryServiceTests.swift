//
//  MockCategoryService.swift
//  EleganceHubTests
//
//  Created by raneem on 21/06/2024.
//

import XCTest
@testable import EleganceHub

final class MockCategoryServiceTests: XCTestCase {
    
    var mockObject : MockCategoryService!
    
    override func setUpWithError() throws {
        mockObject = MockCategoryService(shouldReturnError: false)
    }
    
    override func tearDownWithError() throws {
        mockObject = nil
    }
    
    func testGetFixtureNetwork(){
        mockObject.getCategoryProducts(collectionId: "484444274963", completionHandler:{ result,error in
            if let error = error {
                XCTFail()
            }else{
                XCTAssertNotNil(result)
            }
            
        })
    }
}
