////
////  PaymentNetworkServiceTest.swift
////  EleganceHubTests
////
////  Created by AYA on 19/06/2024.
////
//
//import XCTest
//@testable import EleganceHub 
//
//final class PaymentNetworkServiceTest:XCTestCase{
//    let orderId = 1157421498643
//    var networkService:PaymentServiceProtocol?
//    override func setUpWithError() throws {
//        networkService = PaymentNetworkService()
//    }
//    
//    override func tearDownWithError() throws {
//        networkService = nil
//        
//    }
//    
//    func testCompleteDraftOrderSuccess(){
//        let expectation = self.expectation(description: "Fetch cities succeeds")
//        networkService?.completeDraftOrder(orderID: orderId, completion: { isComplete, error in
//            XCTAssertTrue(isComplete)
//            expectation.fulfill()
//        })
//        waitForExpectations(timeout: 5, handler: nil)
//
//    }
//    
//}
