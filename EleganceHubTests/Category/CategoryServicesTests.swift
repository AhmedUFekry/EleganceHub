//
//  CategoryServicesTests.swift
//  EleganceHubTests
//
//  Created by raneem on 19/06/2024.
//

import XCTest
@testable import EleganceHub

final class CategoryServicesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetWomenCategory(){
        let brandsExpectation = expectation(description:"waiting for api")
        RemoteDataSource.shared.getCategoryProducts(collectionId: "484444307731", completionHandler: { products,error in
            if let error = error {
                XCTFail("API call failed with error: \(error.localizedDescription)")
            }else {
                XCTAssertNotNil(products?.products)
                //XCTAssertEqual(products?.products?.count,3)
                brandsExpectation.fulfill()
            }
            
        })
        waitForExpectations(timeout: 10)
    }

    func testGetMenCategory(){
        let brandsExpectation = expectation(description:"waiting for api")
        RemoteDataSource.shared.getCategoryProducts(collectionId: "484444274963", completionHandler: { products,error in
            if let error = error {
                XCTFail("API call failed with error: \(error.localizedDescription)")
            }else {
                XCTAssertNotNil(products?.products)
                XCTAssertEqual(products?.products?.count,35)
                brandsExpectation.fulfill()
            }
            
        })
        waitForExpectations(timeout: 10)
    }
    
    func testGetKidsCategory(){
        let brandsExpectation = expectation(description:"waiting for api")
        RemoteDataSource.shared.getCategoryProducts(collectionId: "484444340499", completionHandler: { products,error in
            if let error = error {
                XCTFail("API call failed with error: \(error.localizedDescription)")
            }else {
                XCTAssertNotNil(products?.products)
                XCTAssertEqual(products?.products?.count,6)
                brandsExpectation.fulfill()
            }
            
        })
        waitForExpectations(timeout: 10)
    }
    
    func testGetSaleCategory(){
        let brandsExpectation = expectation(description:"waiting for api")
        RemoteDataSource.shared.getCategoryProducts(collectionId: "484444406035", completionHandler: { products,error in
            if let error = error {
                XCTFail("API call failed with error: \(error.localizedDescription)")
            }else {
                XCTAssertNotNil(products?.products)
                XCTAssertEqual(products?.products?.count,3)
                brandsExpectation.fulfill()
            }
            
        })
        waitForExpectations(timeout: 10)
    }
}
