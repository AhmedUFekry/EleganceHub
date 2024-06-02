//
//  LoginViewModel.swift
//  EleganceHub
//
//  Created by Shimaa on 29/05/2024.
//

import Foundation

class LoginViewModel {
    
    var customers: [User] = []
    var bindingLogin: (() -> Void)?
    
    func getAllCustomers() {
    }
    
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


