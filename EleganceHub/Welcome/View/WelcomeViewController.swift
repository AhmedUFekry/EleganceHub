//
//  WelcomeViewController.swift
//  EleganceHub
//
//  Created by Shimaa on 23/05/2024.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func navigateToHomeAsGuest(_ sender: Any){
        
        if let homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                navigationController?.pushViewController(homeViewController, animated: true)
            }
    }
    
  
    @IBAction func navigateToSignUpView(_ sender: Any) {
        if let signUpViewController = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
                navigationController?.pushViewController(signUpViewController, animated: true)
            }
    }
    
    @IBAction func NavigateToLoginView(_ sender: Any) {
        let loginViewController = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        loginViewController.modalPresentationStyle = .fullScreen
            present(loginViewController, animated: true)
    }
    
    
}
