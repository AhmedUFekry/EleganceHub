//
//  UserDefaults.swift
//  EleganceHub
//
//  Created by Shimaa on 08/06/2024.
//

import Foundation
import UIKit

class UserDefaultsHelper:DatabaseServiceProtocol {
 
    static let shared = UserDefaultsHelper()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    func setLoggedInUserID(_ id: Int) {
        userDefaults.set(id, forKey: "loggedInUserID")
    }
    
    func getLoggedInUserID() -> Int? {
        let id = userDefaults.integer(forKey: "loggedInUserID")
        print("getLoggedInUserID \(id)")
        return id != 0 ? id : nil
    }
    
    func clearLoggedInUserID() {
        userDefaults.removeObject(forKey: "loggedInUserID")
    }
    
    func setLoggedIn(_ loggedIn: Bool) {
        userDefaults.set(loggedIn, forKey: "isLoggedIn")
    }
    
    func isLoggedIn() -> Bool {
        return userDefaults.bool(forKey: "isLoggedIn")
    }
    
    func clearLoggedIn() {
        userDefaults.set(false, forKey: "isLoggedIn")
    }
    
    func setIfDataFound(_ id: Int,key: String) {
         userDefaults.set(id, forKey: key)
     }
     
     func getDataFound(key:String) -> Int? {
         let id = userDefaults.integer(forKey: key)
         print("\(key) \(id)")
         return id
         //!= 0 ? id : nil
     }
     
     func clearUserData(key:String) {
         userDefaults.removeObject(forKey: key)
     }
     
     func isDataFound(key:String) -> Bool {
         return userDefaults.bool(forKey: key)
     }
    
    func saveImage(_ image: UIImage) {
        if let imageData = image.pngData() {
            userDefaults.set(imageData, forKey: "savedImage")
        }
    }

    func getImage() -> UIImage? {
        if let imageData = userDefaults.data(forKey: "savedImage") {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    func clearImageProfile() {
        userDefaults.removeObject(forKey: "savedImage")
    }
    
}


