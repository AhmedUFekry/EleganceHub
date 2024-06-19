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
    
   
    
    
    
   
    
    
    
}
