//
//  SignUpViewController.swift
//  EleganceHub
//
//  Created by Shimaa on 23/05/2024.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var fNameTxt: UITextField!
    @IBOutlet weak var lNameTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleSignUpButton()
    }
            
        
    private func styleSignUpButton() {
    registerButton.layer.cornerRadius = 100
    registerButton.backgroundColor = .black
    registerButton.tintColor = .black
    registerButton.layer.borderWidth = 1.0
    registerButton.setTitleColor(.white, for: .normal)
        }
    
    
    @IBAction func signUp(_ sender: Any) {
        guard let firstName = fNameTxt.text, !firstName.isEmpty,
              let lastName = lNameTxt.text, !lastName.isEmpty,
              let phone = phoneTxt.text, !phone.isEmpty,
              let email = emailTxt.text, !email.isEmpty,
              let password = passwordTxt.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTxt.text, !confirmPassword.isEmpty else {
                displayAlert(message: "Please fill all fields", seconds: 2.0)
                return
            }
                
        guard isValidPhone(phone) else {
            displayAlert(message: "Please enter a valid phone number", seconds: 2.0)
            return
        }
                
        guard password == confirmPassword else {
            displayAlert(message: "Passwords do not match", seconds: 2.0)
            return
        }
                
        let fullName = "\(firstName) \(lastName)"
                
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.displayAlert(message: "Error creating user: \(error.localizedDescription)", seconds: 2.0)
                return
            }
                    
            if let user = authResult?.user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = fullName
                changeRequest.commitChanges { error in
                    if let error = error {
                    self.displayAlert(message: "Error updating user profile: \(error.localizedDescription)", seconds: 2.0)
                    } else {
                    self.displayAlert(message: "User signed up successfully", seconds: 2.0)
                    self.navigateToHome()
                }
            }
        }
    }
}
    
    private func displayAlert(message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
        alert.dismiss(animated: true)
        }
    }
        
    private func navigateToHome() {
        if let homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
    
    private func isValidPhone(_ phone: String) -> Bool {
            let phoneRegex = "^01[0-2][0-9]{8}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phoneTest.evaluate(with: phone)
        }
}
