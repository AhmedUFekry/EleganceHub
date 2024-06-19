//
//  SettingsNetworkServiceTest.swift
//  EleganceHubTests
//
//  Created by AYA on 19/06/2024.
//

import XCTest

@testable import EleganceHub
final class SettingsNetworkServiceTest: XCTestCase {
    let customerID =  8229959500051
    let phone = "0123456789"
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUpdateUserDataSuccess(){
        let expectation = self.expectation(description: "Update User Data succeeds")
        
        SettingsNetworkService.updateUserData(customerID: customerID, firstName: "Aya", lastName: "Hany", email: "aayahanyy@gmail.com", phone: phone)
            .subscribe(onNext: { response in
                XCTAssertNotNil(response)
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Expected success, got error \(error)")
            })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetUserInfoSuccess(){
        let expectation = self.expectation(description: "Get User Data succeeds")
        
        SettingsNetworkService.getUserInfo(customerID: customerID)
            .subscribe(onNext: { response in
                XCTAssertEqual(response.customer?.id, self.customerID)
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Expected success, got error \(error)")
            })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
