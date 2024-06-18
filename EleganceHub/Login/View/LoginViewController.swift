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
        
        setupUI()
    }
        
    private func setupUI() {
        setupTextFields()
        setupLoginButton()
        setupSignUpLabel()
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
                self.loginViewModel?.getAllCustomers(completion: { result in
                    switch result {
                    case .success(let customers):
                        if let filteredCustomer = customers.first(where: { $0.email == email }) {
                            if let customerID = filteredCustomer.id {
                                UserDefaultsHelper.shared.setLoggedInUserID(customerID)
                                UserDefaultsHelper.shared.setLoggedIn(true)
                            }
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
        Constants.displayToast(viewController: self, message: message, seconds: seconds)
    }
        
    private func navigateToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? UITabBarController {
            tabBarController.modalPresentationStyle = .fullScreen
            present(tabBarController, animated: true, completion: nil)
        }
    }
    }

// MARK: - UI Setup

extension LoginViewController {
    
    private func setupTextFields() {
        Constants.authTextFieldStyle(tF: mailTxt)
        Constants.authTextFieldStyle(tF: passTxt)
        passTxt.isSecureTextEntry = true
        Constants.addPasswordToggleButton(to: passTxt, target: self, action: #selector(togglePasswordVisibility(_:)))
    }
    
    private func setupLoginButton() {
        loginButton.layer.cornerRadius = 10
        loginButton.backgroundColor = .black
        loginButton.tintColor = .black
        loginButton.setTitleColor(.white, for: .normal)
    }
    
    private func setupSignUpLabel() {
        signUpLabel = UILabel()
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.textAlignment = .center
        
        let text = "Don't have an account? Sign Up"
        let attributedString = NSMutableAttributedString(string: text)
        let signUpRange = (text as NSString).range(of: "Sign Up")
        
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: NSMakeRange(0, text.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: signUpRange)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: signUpRange)
        
        signUpLabel.attributedText = attributedString
        signUpLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signUpLabelTapped))
        signUpLabel.addGestureRecognizer(tapGesture)
        
        view.addSubview(signUpLabel)
        
        NSLayoutConstraint.activate([
            signUpLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            signUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    @objc private func signUpLabelTapped() {
        navigateToSignUp()
    }
    
    private func navigateToSignUp() {
        if let signUpViewController = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            navigationController?.pushViewController(signUpViewController, animated: true)
        }
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        passTxt.isSecureTextEntry = !sender.isSelected
    }
    
}
