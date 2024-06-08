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
    private var signUpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel = LoginViewModel(service: NetworkService())
        
        if UserDefaultsHelper.shared.isLoggedIn() {
            navigateToHome()
        }
        styleLogInButton()
        setupSignUpLabel()
    }
    
    private func styleLogInButton() {
        loginButton.layer.cornerRadius = 100
        loginButton.backgroundColor = .black
        loginButton.tintColor = .black
        loginButton.layer.borderWidth = 1.0
        loginButton.setTitleColor(.white, for: .normal)
    }
    
    private func setupSignUpLabel() {
        signUpLabel = UILabel()
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.textAlignment = .center
                    
        let text = "Don't have an account? Sign Up"
        let attributedString = NSMutableAttributedString(string: text)
        let loginRange = (text as NSString).range(of: "Sign Up")
                    
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: NSMakeRange(0, text.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: loginRange)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: loginRange)
                    
        signUpLabel.attributedText = attributedString
        signUpLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loginLabelTapped))
        signUpLabel.addGestureRecognizer(tapGesture)
                    
        view.addSubview(signUpLabel)
                    
        NSLayoutConstraint.activate([
            signUpLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            signUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }

    @objc private func loginLabelTapped() {
            navigateToSignUp()
        }
        
        func navigateToSignUp() {
            if let signUpViewController = storyboard?.instantiateViewController(identifier: "SignUpViewController") as? SignUpViewController {
                navigationController?.pushViewController(signUpViewController, animated: true)
            }
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
                // on success
                self.loginViewModel?.getAllCustomers(completion: { result in
                    switch result {
                        case .success(let customers):
                            print("Fetched Customers:")
                            if let filteredCustomer = customers.first(where: { $0.email == email }) {
                                print(filteredCustomer)
                                if let customerID = filteredCustomer.id {
                                    UserDefaultsHelper.shared.setLoggedInUserID(customerID)
                                    UserDefaultsHelper.shared.setLoggedIn(true)
                                    print("Customer ID saved in UserDefaults: \(customerID)")
                                }
                            } else {
                                print("No customer found with the given email.")
                            }
                            self.navigateToHome()
                        case .failure(let error):
                        print("Error fetching customers: \(error.localizedDescription)")
                }
            })
        }
    }
}
    
    @IBAction func navigateToPreScreen(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
            }
            
            private func displayToast(message: String, seconds: Double) {
                let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                self.present(alert, animated: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                    alert.dismiss(animated: true)
                }
            }
            
            private func navigateToHome() {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? UITabBarController {
                    tabBarController.modalPresentationStyle = .fullScreen
                    present(tabBarController, animated: true, completion: nil)
                }
            }
        }
