//
//  OrdersViewModelTests.swift
//  EleganceHubTests
//
//  Created by raneem on 19/06/2024.
//

import XCTest
@testable import EleganceHub

final class OrdersViewModelTests: XCTestCase {
    var orderViewModel : OrdersViewModel!
    
    override func setUpWithError() throws {
        orderViewModel = OrdersViewModel(orderService: OrdersService())
    }

    override func tearDownWithError() throws {
       orderViewModel = nil
    }
    
    func testGetOrders(){
        
        let expectation = expectation(description: "Waiting for the API Data")
        orderViewModel?.getOrders(customerId: "8268495585555")
        orderViewModel.bindResultToViewController = { [weak self] in
            XCTAssertNotNil(self?.orderViewModel?.viewModelresult)
            XCTAssertNotNil(self?.orderViewModel.viewModelresult?.count, "ViewModel result should contain orders")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    func testgetOrderForCustomer(){
        
        let expectation = expectation(description: "Waiting for the API Data")
        orderViewModel?.getOrderForCustomer(orderID: 1157792760083)
        orderViewModel.bindDraftOrder = { [weak self] in
            XCTAssertNotNil(self?.orderViewModel?.draftOrderitems)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    func testDeleteOrderForCustomer(){
        
        let expectation = expectation(description: "Waiting for the API Data")
        orderViewModel?.deleteOrder(orderId:1157792760083)
        orderViewModel.bindingOrderDelete = { [weak self] in
            XCTAssertNotNil(self?.orderViewModel?.observableDeleteOrder)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }

}
