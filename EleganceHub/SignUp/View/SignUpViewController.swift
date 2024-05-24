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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        guard let firstName = fNameTxt.text, !firstName.isEmpty,
                      let lastName = lNameTxt.text, !lastName.isEmpty,
                      let phone = phoneTxt.text, !phone.isEmpty,
                      let email = emailTxt.text, !email.isEmpty,
                      let password = passwordTxt.text, !password.isEmpty,
                      let confirmPassword = confirmPasswordTxt.text, !confirmPassword.isEmpty else {
                    displayToast(message: "Please fill all fields", seconds: 2.0)
                    return
                }
                
                guard isValidPhone(phone) else {
                    displayToast(message: "Please enter a valid phone number", seconds: 2.0)
                    return
                }
                
                guard password == confirmPassword else {
                    displayToast(message: "Passwords do not match", seconds: 2.0)
                    return
                }
                
                let fullName = "\(firstName) \(lastName)"
                
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        self.displayToast(message: "Error creating user: \(error.localizedDescription)", seconds: 2.0)
                        return
                    }
                    
                    if let user = authResult?.user {
                        let changeRequest = user.createProfileChangeRequest()
                        changeRequest.displayName = fullName
                        changeRequest.commitChanges { error in
                            if let error = error {
                                self.displayToast(message: "Error updating user profile: \(error.localizedDescription)", seconds: 2.0)
                            } else {
                                self.displayToast(message: "User signed up successfully", seconds: 2.0)
                                self.navigateToHome()
                            }
                        }
                    }
                }
            }
    
        
        private func displayToast(message: String, seconds: Double) {
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
