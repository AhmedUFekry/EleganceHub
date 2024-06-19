//
//  LoginViewModel.swift
//  EleganceHub
//
//  Created by Shimaa on 29/05/2024.
//


import Foundation
import Alamofire
import FirebaseAuth


class LoginViewModel {
    
    var customers: [User] = []
    var bindingLogin: (() -> Void)?
    var service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol) {
        self.service = service
    }
    
    func getAllCustomers(completion: @escaping (Result<[User], Error>) -> Void) {
       
        let parameters: Parameters = ["limit": 10] 
        
        service.getUsers(parameters: parameters) { response in
            if let response = response {
                self.customers = response.customers
                completion(.success(response.customers))
            } else {
                let error = NSError(domain: "FetchError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch customers"])
                completion(.failure(error))
            }
        }
    }
    
    func checkCustomerAuth(customerEmail: String, customerPassword: String, completion: @escaping (String) -> Void) {
        guard !customerEmail.isEmpty, !customerPassword.isEmpty else {
            completion("Enter Full Data")
            return
        }
        
        if let customer = customers.first(where: { $0.email == customerEmail }) {
            if customer.password == customerPassword {
                completion("Login Success")
            } else {
                completion("Incorrect Email or Password")
            }
        } else {
            completion("Incorrect Email or Password")
        }
    }
    
    func logout() {
            UserDefaultsHelper.shared.clearLoggedInUserID()
            UserDefaultsHelper.shared.clearLoggedIn()
            UserDefaultsHelper.shared.clearImageProfile()
            UserDefaultsHelper.shared.clearUserData(key: UserDefaultsConstants.getDraftOrder.rawValue)
            
            // Optionally, sign out from Firebase Auth
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError)")
            }
        }
}



