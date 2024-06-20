//
//  ProductBrandServicesTests.swift
//  EleganceHubTests
//
//  Created by raneem on 19/06/2024.
//

import XCTest
@testable import EleganceHub

final class ProductBrandServicesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetProductsForBrands(){
        let brandsExpectation = expectation(description:"waiting for api")
        RemoteDataSource.shared.getProducts(collectionId: 484442276115, completionHandler: { products,error in
            if let error = error {
                XCTFail("API call failed with error: \(error.localizedDescription)")
            }else {
                XCTAssertNotNil(products?.products)
               // XCTAssertEqual(products?.products?.count,3)
                brandsExpectation.fulfill()
            }
        })
        waitForExpectations(timeout: 30)
    }


}
