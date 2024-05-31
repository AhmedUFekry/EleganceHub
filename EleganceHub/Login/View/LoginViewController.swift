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
        styleLogInButton()
        setupSignUpLabel()
        loginViewModel = LoginViewModel()
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
    
    func navigateToSignUp(){
        if let loginViewController = storyboard?.instantiateViewController(identifier: "LoginViewController") as? LoginViewController{
            navigationController?.pushViewController(loginViewController, animated: true)
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
            self.navigateToHome()
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
        if let homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            let nav = UINavigationController(rootViewController: homeViewController)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
}
