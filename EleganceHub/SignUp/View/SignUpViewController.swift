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
    @IBOutlet weak var backButton: UIButton!
    
    var signViewModel: SignViewModel?
    private var loginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signViewModel = SignViewModel()
        setupUI()
        setupBindings()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let  isDarkMode = UserDefaultsHelper.shared.isDarkMode()
        if isDarkMode{
            backButton.setImage(UIImage(named: "backLight"), for: .normal)
        }else{
            backButton.setImage(UIImage(named: "back"), for: .normal)
        }
    }
        
    private func setupBindings() {
        signViewModel?.bindingSignUp = { [weak self] in
            DispatchQueue.main.async {
                if let statusCode = self?.signViewModel?.ObservableSignUp {
                    switch statusCode {
                    case 201:
                        self?.navigateToLogin()
                    case 422:
                        self?.displayAlert(title: "Your request couldn't be processed due to some errors. Please try again Later.", message: "", seconds: 3.0)
                    case 0:
                        self?.displayAlert(title: "Something went wrong, Please check your information and try again.", message: "", seconds: 3.0)
                    default:
                        self?.displayAlert(title: "Something went wrong", message: "Unable to sign up due to an error, Please try again.", seconds: 3.0)
                    }
                }
            }
        }
    }
        
    @objc private func loginLabelTapped() {
        navigateToLogin()
    }
        
    @IBAction func signUp(_ sender: Any) {
        guard let firstName = fNameTxt.text, !firstName.isEmpty,
                let lastName = lNameTxt.text, !lastName.isEmpty,
                let phone = phoneTxt.text, !phone.isEmpty,
                let email = emailTxt.text, !email.isEmpty,
                let password = passwordTxt.text, !password.isEmpty,
                let confirmPassword = confirmPasswordTxt.text, !confirmPassword.isEmpty else {
            displayAlert(title: "Please fill all fields", message: "", seconds: 2.0)
            return
        }
            
        guard isValidPhone(phone) else {
            displayAlert(title: "Please enter a valid phone number", message: "", seconds: 2.0)
            return
        }
            
        guard password == confirmPassword else {
            displayAlert(title: "Passwords do not match", message: "", seconds: 2.0)
            passwordTxt.text = ""
            confirmPasswordTxt.text = ""
            return
        }
            
        let fullName = "\(firstName) \(lastName)"
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.displayAlert(title: "Oops", message: "Something went wrong while creating your account , Please try again later.", seconds: 2.0)
                return
            }
            
            if let user = authResult?.user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = fullName
                changeRequest.commitChanges { error in
                    if let error = error {
                        self.displayAlert(title: "Oops", message: "Something went wrong while updating your account , Please try again later.", seconds: 2.0)
                    } else {
                        self.sendVerificationEmail(user: user)
                        let user = User(first_name: firstName, last_name: lastName, email: email, password: password)
                        self.signViewModel?.insertCustomer(user: user)
                    }
                }
            }
        }
    }
        
    @IBAction func navigateToPreScreen(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
        
    private func displayAlert(title:String, message: String, seconds: Double, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true) {
                completion?()
            }
        }
    }
        
    private func sendVerificationEmail(user: FirebaseAuth.User) {
        self.fNameTxt.text = ""
        self.lNameTxt.text = ""
        self.phoneTxt.text = ""
        self.emailTxt.text = ""
        self.passwordTxt.text = ""
        self.confirmPasswordTxt.text = ""
        
        user.sendEmailVerification { [self] error in
            if let error = error {
                self.displayAlert(title: "Oops", message: "Something went wrong while sending verification email.", seconds: 2.0)
                return
            }
            self.displayAlert(title: "Verification email sent", message: "Please check your inbox.", seconds: 2.0)
            //self.navigateToLogin()
            
        }
    }
        
    private func navigateToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? UITabBarController {
            tabBarController.modalPresentationStyle = .fullScreen
            present(tabBarController, animated: true, completion: nil)
        }
    }
        
    private func navigateToLogin() {
        if let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            navigationController?.pushViewController(loginViewController, animated: true)
        }
        
        
    }
        
    private func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = "^01[0-2][0-9]{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTextFieldStyle()
    }
}

    // MARK: - UI Setup Extension

extension SignUpViewController {
    
    private func setupUI() {
        styleSignUpButton()
        setupLoginLabel()
        setupPasswordFields()
        setTextFieldStyle()
    }
    
    private func setTextFieldStyle(){
        Constants.textFieldStyle(tF: fNameTxt)
        Constants.textFieldStyle(tF: lNameTxt)
        Constants.textFieldStyle(tF: phoneTxt)
        Constants.textFieldStyle(tF: emailTxt)
        Constants.textFieldStyle(tF: passwordTxt)
        Constants.textFieldStyle(tF: confirmPasswordTxt)
    }
    
    private func styleSignUpButton() {
        registerButton.layer.cornerRadius = 10
        registerButton.backgroundColor = .black
        registerButton.tintColor = .black
        registerButton.setTitleColor(.white, for: .normal)
    }
    
    private func setupLoginLabel() {
        loginLabel = UILabel()
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.textAlignment = .center
        
        let text = "Already have an account? Login"
        let attributedString = NSMutableAttributedString(string: text)
        let loginRange = (text as NSString).range(of: "Login")
        
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: NSMakeRange(0, text.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.secondaryLabel, range: loginRange)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: loginRange)
        
        loginLabel.attributedText = attributedString
        loginLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loginLabelTapped))
        loginLabel.addGestureRecognizer(tapGesture)
        
        view.addSubview(loginLabel)
        
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 10),
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    private func setupPasswordFields() {
        passwordTxt.isSecureTextEntry = true
        confirmPasswordTxt.isSecureTextEntry = true
        setupPasswordToggleButtons()
    }
    
    private func setupPasswordToggleButtons() {
        Constants.addPasswordToggleButton(to: passwordTxt, target: self, action: #selector(togglePasswordVisibility(_:)))
        Constants.addPasswordToggleButton(to: confirmPasswordTxt, target: self, action: #selector(togglePasswordVisibility(_:)))
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        if let textField = sender.superview?.superview as? UITextField {
            textField.isSecureTextEntry.toggle()
        }
    }
    
}
