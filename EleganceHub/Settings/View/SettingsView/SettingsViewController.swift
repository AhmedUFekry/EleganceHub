//
//  SettingsViewController.swift
//  EleganceHub
//
//  Created by AYA on 25/05/2024.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var switchDarkToggle: UISwitch!
    @IBOutlet weak var userFirstNameTF: UITextField!
    @IBOutlet weak var userEmailTF: UITextField!
    @IBOutlet weak var userLastNameTF: UITextField!
    @IBOutlet weak var userPhoneTF: UITextField!
    @IBOutlet weak var appBarView:CustomAppBarUIView!
    @IBOutlet weak var profileImageView:ProfileImageUIView!
    @IBOutlet weak var logOutBtn:UIButton!
    @IBOutlet weak var uiViewStyle:UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var imageString: String?
    var isEditingTapped: Bool = false
    var customerID:Int?
    var customerData:Customer?
    var updateViewDelegate: UpdateThemaDelegate?
    
    let viewModel = SettingsViewModel()
    let disposeBag = DisposeBag()
    
    var loginViewModel: LoginViewModel?
        
    @IBAction func darkModeSwitch(_ sender: UISwitch) {
        if #available(iOS 13.0, *) {
            let appDelegate = UIApplication.shared.windows.first
            if sender.isOn {
                UserDefaultsHelper.shared.setDarkMode(true)
                
                appDelegate?.overrideUserInterfaceStyle = .dark
            } else {
                UserDefaultsHelper.shared.setDarkMode(false)
                appDelegate?.overrideUserInterfaceStyle = .light
            }
        }
        themeUpdated()
        updateViewDelegate?.updateView()
    }

    private func setupDarkModeSwitch() {
        switchDarkToggle.isOn = UserDefaultsHelper.shared.isDarkMode()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        uISetUp()
        bindViewModel()
        setupDarkModeSwitch()
        
        customerID = UserDefaultsHelper.shared.getLoggedInUserID()
        
        viewModel.loadImage()
        if let savedImage = viewModel.savedImage {
            profileImageView.profileImage.image = savedImage
        }
        
        loginViewModel = LoginViewModel(service: NetworkService())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //applySavedTheme()
        themeUpdated()
    }
    
    func themeUpdated(){
        let  isDarkMode = UserDefaultsHelper.shared.isDarkMode()
        if isDarkMode{
            appBarView.backBtn.setImage(UIImage(named: "backLight"), for: .normal)
            logOutBtn.setImage(UIImage(named: "logout-dark"), for: .normal)
        }else{
            appBarView.backBtn.setImage(UIImage(named: "back"), for: .normal)
            logOutBtn.setImage(UIImage(named: "logout"), for: .normal)
        }
       
    }
    private func setUpTextFieldStyle(){
        Constants.textFieldStyle(tF: userFirstNameTF)
        Constants.textFieldStyle(tF: userEmailTF)
        Constants.textFieldStyle(tF: userLastNameTF)
        Constants.textFieldStyle(tF: userPhoneTF)
    }
    private func uISetUp() {
        setUpTextFieldStyle()
        uiViewStyle.layer.borderWidth = 1
        uiViewStyle.layer.cornerRadius = 10
        uiViewStyle.layer.borderColor = UIColor.gray.cgColor
        
        appBarView.secoundTrailingIcon.isHidden = true
        appBarView.trailingIcon.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        
        appBarView.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        appBarView.trailingIcon.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        appBarView.lableTitle.text = "Personal Details"
        
        profileImageView.editPicBtn.addTarget(self, action: #selector(editImageTapped), for: .touchUpInside)
        self.userEmailTF.isEnabled = false
        enableEditting(isEnable: isEditing)
    }
        
    @objc func editImageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
        
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
        
    @objc func editButtonTapped() {
        if (isEditing) {
            print("Update Data")
            if let newImage = profileImageView.profileImage.image {
                viewModel.saveImage(newImage)
            }
            guard let id = customerID else {return}
            
            guard let firstName = userFirstNameTF.text, !firstName.isEmpty,
                    let lastName = userLastNameTF.text, !lastName.isEmpty,
                  let phone = userPhoneTF.text, !phone.isEmpty else{
                      Constants.displayAlert(viewController: self, message: "Please enter a valid data.", seconds: 2.0)
                      return
            }
            guard isValidPhone(phone) else {
                Constants.displayAlert(viewController: self, message: "Please enter a valid phone number.", seconds: 2.0)
                return
            }
            viewModel.updateData(customerID: id, firstName: firstName, lastName: lastName, email: userEmailTF.text, phone: phone)
        }
        isEditing = !isEditing
        isEditing ? appBarView.trailingIcon.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal) : appBarView.trailingIcon.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        enableEditting(isEnable: isEditing)
    }
        
    private func enableEditting(isEnable: Bool) {
        profileImageView.editPicBtn.isHidden = !isEnable
        self.userFirstNameTF.isEnabled = isEnable
        //self.userEmailTF.isEnabled = isEnable
        self.userLastNameTF.isEnabled = isEnable
        self.userPhoneTF.isEnabled = isEnable
        
        profileImageView.uploadLabel.text = isEnable ? "Upload image" : ""
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpTextFieldStyle()
    }
    private func bindViewModel() {
        loadingObserverSetUp()
        onErrorObserverSetUp()
        if let customerData = self.customerData{
            self.updateUI(with: customerData)
        }else{
            if let id = UserDefaultsHelper.shared.getLoggedInUserID(){
                viewModel.loadUSerData(customerID: id)
            }
        }
        
        viewModel.customerResponse
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if let response = response.customer {
                    // self.customerData = response.customer
                    if (self.isEditing) {
                        Constants.displayAlert(viewController: self, message: "Your changes have been updated successfully.", seconds: 2.0)
                    }
                    self.customerData = response
                    self.updateUI(with: response)
                }
            })
            .disposed(by: disposeBag)
    }
        
    
    
    @IBAction func logout(_ sender: Any) {
        loginViewModel?.logout()
        navigateToWelcomeScreen()
        print(UserDefaultsHelper.shared.getLoggedInUserID())
    }
            
    private func navigateToWelcomeScreen() {
        if let newViewController = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") {
                newViewController.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(newViewController, animated: true)
            }
    }
    private func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = "^01[0-2][0-9]{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
}


extension SettingsViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
                    profileImageView.profileImage.image = selectedImage
                }
        self.dismiss(animated: true)
    }
    
    private func loadingObserverSetUp(){
        viewModel.isLoading.subscribe{ isloading in
            self.showActivityIndicator(isloading)
        }.disposed(by: disposeBag)
    }
    
    private func showActivityIndicator(_ show: Bool) {
        if show {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }
    private func onErrorObserverSetUp(){
        viewModel.error.subscribe{ err in
            self.showAlertError(err: err.error?.localizedDescription ?? "Error")
        }.disposed(by: disposeBag)
    }
    private func showAlertError(err:String){
        Constants.displayAlert(viewController: self,message: err, seconds: 3)
    }
    
    private func updateUI(with user: Customer) {
        userFirstNameTF.text = user.firstName
        userLastNameTF.text = user.lastName
        userEmailTF.text = user.email
        userPhoneTF.text = user.phone
    }
}
