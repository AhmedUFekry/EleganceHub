//
//  ProfileNetworkServiceTest.swift
//  EleganceHubTests
//
//  Created by AYA on 19/06/2024.
//

import XCTest

@testable import EleganceHub
final class ProfileNetworkServiceTest: XCTestCase {
    let customerID =  8229959500051
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchCitiesSuccess() {
        let expectation = self.expectation(description: "Fetch cities succeeds")
        
        NetworkService.fetchCities(country: "egypt") { result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response.data)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, got failure")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testPostNewAddressSuccess() {
        let expectation = self.expectation(description: "Post new address succeeds")
    
        let addressData = AddressData(address1: "123 Main St", address2: "", city: "City", company: "", firstName: "John", lastName: "Doe", phone: "1234567890", province: "Province", country: "Country", zip: "12345", name: "John Doe", provinceCode: "", countryCode: "", countryName: "Country")
        
        NetworkService.postNewAddress(customerID: customerID, addressData: addressData) { result in
            switch result {
            case .success(let response):
                print("Response \(response)")
                //XCTAssertEqual(response.customerAddress?.customerID, self.customerID)
                XCTAssertNotNil(response)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, got failure")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetAllAddressesSuccess() {
        let expectation = self.expectation(description: "Get all addresses succeeds")
            
        _ = NetworkService.getAllAddresses(customerID: customerID)
            .subscribe(onNext: { response in
                XCTAssertNotNil(response.addresses)
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Expected success, got error \(error)")
            })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    func testRemoveAddress(){
        let expectation = self.expectation(description: "Remove address succeeds")
        NetworkService.removeAddress(customerID: customerID, addressID: 10052031217939)
            .subscribe(onNext: { _ in
               XCTAssertTrue(true)
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Expected success, got error \(error)")
            })
        waitForExpectations(timeout: 5, handler: nil)

    }
    
    func testGetProductsSuccess() {
       let expectation = self.expectation(description: "Get products succeeds")
       
        NetworkService().getProducts(parameters: [:]) { response in
            if let result = response {
                XCTAssertNotNil(result.products)
                expectation.fulfill()
            }else{
                XCTFail("Expected success, got error")
            }
        }
       waitForExpectations(timeout: 5, handler: nil)
   }
    func testGetUsersSuccess() {
      let expectation = self.expectation(description: "Get users succeeds")
      
      NetworkService().getUsers(parameters: [:]) { response in
          if let result = response {
              XCTAssertNotNil(result)
              expectation.fulfill()
          }else{
              XCTFail("Expected success, got error")
          }
      }
      waitForExpectations(timeout: 5, handler: nil)
  }
  
}
