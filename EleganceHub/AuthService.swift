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
    
    public func registerUser(with userRequest: AuthUserRequest, completion: @escaping (Bool, Error?)->Void) {
        
        let email = userRequest.email
        let password = userRequest.password
                
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
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
    
    public func signIn(with userRequest: AuthUserRequest, completion: @escaping (Error?)->Void) {
        Auth.auth().signIn(
            withEmail: userRequest.email,
            password: userRequest.password
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
