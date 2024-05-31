//
//  UserModel.swift
//  EleganceHub
//
//  Created by Shimaa on 24/05/2024.
//

import Foundation

struct AuthUser:Codable{
    var users:[User]
}

struct User:Codable {
    var id:Int?
    var first_name:String?
    var last_name:String?
    let email: String?
    let password: String?
    var addresses:[String]?
    //var note:String?
}




