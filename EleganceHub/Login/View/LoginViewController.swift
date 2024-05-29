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
    
    var loginViewModel: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel = LoginViewModel()
        
        

        // Do any additional setup after loading the view.
    }
    

  
    @IBAction func logToAccount(_ sender: Any) {
        guard let email = mailTxt.text, !email.isEmpty,
                      let password = passTxt.text, !password.isEmpty else {
                    displayToast(message: "Please fill all fields", seconds: 2.0)
                    return
                }
                
                Auth.auth().fetchSignInMethods(forEmail: email) { signInMethods, error in
                    if let error = error {
                        self.displayToast(message: "Error checking email: \(error.localizedDescription)", seconds: 2.0)
                        return
                    }
                    
                    guard let signInMethods = signInMethods, !signInMethods.isEmpty else {
                        self.displayToast(message: "This email is not registered", seconds: 2.0)
                        return
                    }
                    
//                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//                        if let error = error as NSError? {
//                            switch AuthErrorCode(rawValue: error.code) {
//                            case .wrongPassword:
//                                self.displayToast(message: "Incorrect password", seconds: 2.0)
//                            case .some(let authErrorCode):
//                                self.displayToast(message: "Error logging in: \(authErrorCode.errorMessage)", seconds: 2.0)
//                            default:
//                                self.displayToast(message: "Error logging in: \(error.localizedDescription)", seconds: 2.0)
//                            }
//                            return
//                        }
//                        
//                        if authResult?.user != nil {
//                            self.navigateToHome()
//                        }
//                    }
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

//extension AuthErrorCode {
//    var errorMessage: String {
//        switch self {
//        case .wrongPassword:
//            return "Incorrect password"
//        case .invalidEmail:
//            return "Invalid email"
//        case .userNotFound:
//            return "User not found"
//        case .networkError:
//            return "Network error"
//        default:
//            return "Unknown error occurred"
//        }
//    }
//}
