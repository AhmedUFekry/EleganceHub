//
//  AuthService.swift
//  EleganceHub
//
//  Created by Shimaa on 24/05/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService{
    
    public static let shared = AuthService()
    
    private init(){}
    
    public func signUp(with userRequest: User, completion: @escaping (Bool, Error?)->Void) {
        
        let email = userRequest.email
        guard let password = userRequest.password else { return  }
                
        Auth.auth().createUser(withEmail: email ?? "not found", password: password) { result, error in
            if let error = error {
                completion(false, error)
                    return
                }
            guard let resultUser = result?.user else {
                completion(false, nil)
                    return
            }
            let db = Firestore.firestore()
            db.collection("users")
                .document(resultUser.uid)
                .setData([
                    "email": email
                ]) { error in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                completion(true, nil)
            }
        }
    }
    
    public func signIn(with userRequest: User, completion: @escaping (Error?)->Void) {
        Auth.auth().signIn(
            withEmail: userRequest.email ?? "not found",
            password: userRequest.password ?? "not found"
        ) { result, error in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }
        
    public func signOut(completion: @escaping (Error?)->Void) {
        do {
            try Auth.auth().signOut()
                completion(nil)
        } catch let error {
            completion(error)
        }
    }
}
