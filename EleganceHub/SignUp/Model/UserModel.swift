//
//  UserModel.swift
//  EleganceHub
//
//  Created by Shimaa on 24/05/2024.
//

import Foundation

struct UserResponse:Codable{
    var customers:[User]
}

struct User:Codable {
    var id: Int?
        var first_name: String?
        var last_name: String?
        let email: String?
        let password: String?
        var phone: String?
   // var addresses: [Address]?
}




