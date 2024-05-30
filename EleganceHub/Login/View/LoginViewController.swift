//
//  LoginViewController.swift
//  EleganceHub
//
//  Created by Shimaa on 24/05/2024.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var mailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var loginViewModel: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleLogInButton()
        loginViewModel = LoginViewModel()
    }
    

    private func styleLogInButton() {
    loginButton.layer.cornerRadius = 100
    loginButton.backgroundColor = .black
    loginButton.tintColor = .black
    loginButton.layer.borderWidth = 1.0
    loginButton.setTitleColor(.white, for: .normal)
    }
  
    @IBAction func logToAccount(_ sender: Any) {
        guard let email = mailTxt.text, !email.isEmpty,
            let password = passTxt.text, !password.isEmpty else {
            displayToast(message: "Please fill all fields", seconds: 2.0)
            return
        }
                
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                self.displayToast(message: "Error logging in: \(error.localizedDescription)", seconds: 2.0)
                return
            }
                    
            if authResult?.user != nil {
            self.navigateToHome()
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
            let nav = UINavigationController(rootViewController: homeViewController)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
}
