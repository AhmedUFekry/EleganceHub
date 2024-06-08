//
//  SignUpViewModel.swift
//  EleganceHub
//
//  Created by Shimaa on 30/05/2024.
//

import Foundation

class SignViewModel {
    
    var bindingSignUp:(()->()) = {}
    var ObservableSignUp : Int? {
        didSet {
            bindingSignUp()
        }
    }
    
    func insertCustomer(user:User){
        SignUpNetworkService.userRegister(newUser: user) { checkSignAblitiy in
            self.ObservableSignUp = checkSignAblitiy
        }
    }
}
