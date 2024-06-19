//
//  OrdersServicesTests.swift
//  EleganceHubTests
//
//  Created by raneem on 19/06/2024.
//

import XCTest
@testable import EleganceHub

final class OrdersServicesTests: XCTestCase {

    var ordersService: OrdersServiceProtocol!
    
    override func setUpWithError() throws {
        ordersService = OrdersService()
    }
    
    override func tearDownWithError() throws {
        ordersService = nil
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
