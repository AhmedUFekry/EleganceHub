////
////  SignUpViewModel.swift
////  EleganceHub
////
////  Created by Shimaa on 30/05/2024.
////
//
//import Foundation
//class SignViewModel {
//    
//    var bindingSignUp: (() -> Void) = {}
//    var observableSignUp: (statusCode: Int, responseData: String?)? {
//        didSet {
//            bindingSignUp()
//        }
//    }
//    
//    func insertCustomer(user: User) {
//        SignUpNetworkService.userRegister(newUser: user) { statusCode, responseData in
//            print("Status Code: \(statusCode)")
//            print("Response Data: \(responseData ?? "No data")")
//            self.observableSignUp = (statusCode, responseData)
//        }
//    }
//}
import Foundation

struct SignUpStatus {
    let statusCode: Int
    let responseData: String?
}

class SignViewModel {
    
    var bindingSignUp: (() -> Void) = {}
    var observableSignUp: SignUpStatus? {
        didSet {
            bindingSignUp()
        }
    }
    
    func insertCustomer(user: User) {
        SignUpNetworkService.userRegister(newUser: user) { statusCode, responseData in
            self.observableSignUp = SignUpStatus(statusCode: statusCode, responseData: responseData)
        }
    }
}
