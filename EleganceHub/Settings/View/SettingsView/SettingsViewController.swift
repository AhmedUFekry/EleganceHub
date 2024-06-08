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
        
        var customerData: User? = User(id: 8229959500051, first_name: "shimaa", last_name: "shimo", email: "", password: "")
        
        let viewModel = SettingsViewModel()
        let disposeBag = DisposeBag()
        
        var loginViewModel: LoginViewModel?
        
        override func viewDidLoad() {
            super.viewDidLoad()

            uISetUp()
            bindViewModel()
            
            viewModel.loadImage()
            if let savedImage = viewModel.savedImage {
                profileImageView.profileImage.image = savedImage
            }
            
            loginViewModel = LoginViewModel(service: NetworkService())
        }
        
        private func uISetUp() {
            Constants.textFieldStyle(tF: userFirstNameTF)
            Constants.textFieldStyle(tF: userEmailTF)
            Constants.textFieldStyle(tF: userLastNameTF)
            Constants.textFieldStyle(tF: userPhoneTF)
            
            uiViewStyle.layer.borderWidth = 1
            uiViewStyle.layer.cornerRadius = 10
            uiViewStyle.layer.borderColor = UIColor.gray.cgColor
            
            appBarView.secoundTrailingIcon.isHidden = true
            appBarView.trailingIcon.setImage(UIImage(named: "icons8-edit-35"), for: .normal)
            
            appBarView.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
            appBarView.trailingIcon.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
            
            appBarView.lableTitle.text = "Personal Details"
            
            profileImageView.editPicBtn.addTarget(self, action: #selector(editImageTapped), for: .touchUpInside)
            
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
            isEditing = !isEditing
            isEditing ? appBarView.trailingIcon.setImage(UIImage(named: "icons8-done-35"), for: .normal) : appBarView.trailingIcon.setImage(UIImage(named: "icons8-edit-35"), for: .normal)
            enableEditting(isEnable: isEditing)
            if (!isEditing) {
                print("Update Data")
                if let newImage = profileImageView.profileImage.image {
                    viewModel.saveImage(newImage)
                }
                
                viewModel.updateData(customerID: customerData!.id!, firstName: userFirstNameTF.text, lastName: userLastNameTF.text, email: userEmailTF.text, phone: userPhoneTF.text)
            }
        }
        
        private func enableEditting(isEnable: Bool) {
            profileImageView.editPicBtn.isHidden = !isEnable
            self.userFirstNameTF.isEnabled = isEnable
            self.userEmailTF.isEnabled = isEnable
            self.userLastNameTF.isEnabled = isEnable
            self.userPhoneTF.isEnabled = isEnable
            
            profileImageView.uploadLabel.text = isEnable ? "Upload image" : "Aya Hany"
        }
        
        private func bindViewModel() {
            loadingObserverSetUp()
            onErrorObserverSetUp()
            
            if let id = customerData?.id {
                viewModel.loadUSerData(customerID: id)
            }
            
            viewModel.customerResponse
                .subscribe(onNext: { [weak self] response in
                    guard let self = self else { return }
                    if let response = response.customer {
                        // self.customerData = response.customer
                        if (self.isEditing) {
                            Constants.displayToast(viewController: self, message: "Updated Successfully", seconds: 2.0)
                        } else {
                            Constants.displayToast(viewController: self, message: "data downloaded Successfully", seconds: 2.0)
                        }
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
