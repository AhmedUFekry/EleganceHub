//
//  SignUpViewModelTests.swift
//  EleganceHubTests
//
//  Created by raneem on 20/06/2024.
//

import XCTest
@testable import EleganceHub

final class SignUpViewModelTests: XCTestCase {
    var signViewModel: SignViewModel?

    override func setUpWithError() throws {
         signViewModel = SignViewModel()
    }

    override func tearDownWithError() throws {
         signViewModel = nil
    }

    func testInsertCustomer() {
            let expectation = expectation(description: "Waiting for the API Data")
            
        signViewModel?.bindingSignUp = { [weak self] in
            XCTAssertNotNil(self?.signViewModel?.ObservableSignUp, "ObservableSignUp should not be nil")
           
                expectation.fulfill()
            }
            
         let testUser = User(first_name: "shimaa", last_name: "sami", email: "shimaa.sami@gmail.com", password: "123456", phone: "1234567890")
            
        signViewModel?.insertCustomer(user: testUser)
            
            waitForExpectations(timeout: 15)
        }
    }
