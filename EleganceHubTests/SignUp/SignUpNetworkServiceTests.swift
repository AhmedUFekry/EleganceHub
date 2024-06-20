//
//  SignUpNetworkServiceTests.swift
//  EleganceHubTests
//
//  Created by Shimaa on 20/06/2024.
//

import XCTest
@testable import EleganceHub

final class SignUpNetworkServiceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUserRegistrationSuccess() {

        let expectation = self.expectation(description: "User registration succeeds")
        let newUser = User(first_name: "shimaa", last_name: "sami", email: "shimaa.sami@gmail.com", password: "123456", phone: "1234567890")
        
        var statusCode: Int?
        var isSuccess = false
        
        
        SignUpNetworkService.userRegister(newUser: newUser) { result in
            switch result {
            case 201:
                isSuccess = true
            default:
                statusCode = result
            }
            expectation.fulfill()
        }
        
        
        waitForExpectations(timeout: 10) { error in
            XCTAssertEqual(statusCode, 422, "the status code should be  422 for unsuccessful registration")
        }
    }



}

