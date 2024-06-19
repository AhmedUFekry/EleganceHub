//
//  EleganceHubTests.swift
//  EleganceHubTests
//
//  Created by A7med Fekry on 22/05/2024.
//

import XCTest
@testable import EleganceHub

final class EleganceHubTests: XCTestCase {
    
    var ordersService: OrdersService!
    
    override func setUpWithError() throws {
        ordersService = OrdersService()
    }
    
    override func tearDownWithError() throws {
        ordersService = nil
    }


    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetBrands(){
        let brandsExpectation = expectation(description:"waiting for api")
        RemoteDataSource.shared.getBrands(complationhandler:{result,error in
            if let error = error {
                XCTFail("API call failed with error: \(error.localizedDescription)")
            }else {
                XCTAssertNotNil(result?.smartCollections)
                brandsExpectation.fulfill() // done
            }
            
        })
        waitForExpectations(timeout: 25)
    }
    
    func testGetProducts(){
        let brandsExpectation = expectation(description:"waiting for api")
        RemoteDataSource.shared.getProducts(collectionId: 484442276115, completionHandler: { products,error in
            if let error = error {
                XCTFail("API call failed with error: \(error.localizedDescription)")
            }else {
                XCTAssertNotNil(products?.products)
                XCTAssertEqual(products?.products?.count,3)
                brandsExpectation.fulfill()
            }
            
        })
        waitForExpectations(timeout: 30)
    }
    
    func testGetCategories(){
        let brandsExpectation = expectation(description:"waiting for api")
        RemoteDataSource.shared.getCategoryProducts(collectionId: "484444307731", completionHandler: { products,error in
            if let error = error {
                XCTFail("API call failed with error: \(error.localizedDescription)")
            }else {
                XCTAssertNotNil(products?.products)
                XCTAssertEqual(products?.products?.count,4)
                brandsExpectation.fulfill()
            }
            
        })
        waitForExpectations(timeout: 10)
    }
    
    func testGetOrders(){
        let brandsExpectation = expectation(description:"waiting for api")
        ordersService.getOrders(customerId: "8268495585555", completionHandler:{ orders,error in
            if let error = error {
                XCTFail("API call failed with error: \(error.localizedDescription)")
            }else {
                XCTAssertNotNil(orders?.orders)
               // XCTAssertEqual(orders?.orders?.count,1)
                brandsExpectation.fulfill()
            }
            
        })
        waitForExpectations(timeout: 10)
    }
    func testGetDraftOrders(){
        let brandsExpectation = expectation(description:"waiting for api")
        ordersService.getDraftOrderForUser(orderID: 1157792760083, completionHandler:{ draftOrders,error in
            if let error = error {
                XCTFail("API call failed with error: \(error.localizedDescription)")
            }else {
                XCTAssertNotNil(draftOrders?.draftOrders)
               // XCTAssertEqual(draftOrders?.draftOrders.count,1)
                brandsExpectation.fulfill()
            }
        })
        waitForExpectations(timeout: 10)
    }
    
//  func testDeleteOrder() {
//            let expectation = self.expectation(description: "waiting for api")
//
//            ordersService.deleteOrder(orderID: 5844130070803) { statusCode in
//                XCTAssertEqual(statusCode, 200)
//                expectation.fulfill()
//            }
//
//            waitForExpectations(timeout: 10) { error in
//                if let error = error {
//                    XCTFail("Test timed out with error: \(error.localizedDescription)")
//                }
//            }
//        }
    
    
}
