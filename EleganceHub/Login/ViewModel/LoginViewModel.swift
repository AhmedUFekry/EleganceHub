//
//  LoginViewModel.swift
//  EleganceHub
//
//  Created by Shimaa on 29/05/2024.
//

import Foundation

class LoginViewModel {
    
    var customers: [AuthUserRequest] = []
    var bindingLogin: (() -> Void)?
    
//    func getAllCustomers() {
//        // Simulate fetching customers from a remote source or database.
//        // In a real app, this would involve network requests or database queries.
//        // This is just a placeholder example.
//        
//        // Example customers data
//        customers = [
//            AuthUserRequest(email: "test@example.com", password: "password123"),
//            AuthUserRequest(email: "user@example.com", password: "password456")
//        ]
//        
//        // Notify the view controller that the data has been fetched.
//        bindingLogin?()
//    }
    
    func checkCustomerAuth(customerEmail: String, customerPasssword: String) -> String {
        guard !customerEmail.isEmpty, !customerPasssword.isEmpty else {
            return "Enter Full Data"
        }
        
        if let customer = customers.first(where: { $0.email == customerEmail }) {
            if customer.password == customerPasssword {
                return "Login Success"
            } else {
                return "Uncorrect Email or Password"
            }
        } else {
            return "Uncorrect Email or Password"
        }
    }
}


