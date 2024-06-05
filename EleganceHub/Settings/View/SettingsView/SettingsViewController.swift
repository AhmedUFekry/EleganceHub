//
//  SettingsViewController.swift
//  EleganceHub
//
//  Created by AYA on 25/05/2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    
    @IBOutlet weak var userFirstNameTF: UITextField!
    @IBOutlet weak var userEmailTF: UITextField!
    @IBOutlet weak var userLastNameTF: UITextField!
    @IBOutlet weak var userPhoneTF: UITextField!
    @IBOutlet weak var appBarView:CustomAppBarUIView!
    @IBOutlet weak var profileImageView:ProfileImageUIView!
    @IBOutlet weak var logOutBtn:UIButton!
    @IBOutlet weak var uiViewStyle:UIView!
    var isEditingTapped: Bool = false
    
    var customerData:User? = User(id: 8222308237587, first_name: "shimaa", last_name: "shimo", email: "", password: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uISetUp()
    }
    private func uISetUp(){
        Constants.textFieldStyle(tF: userFirstNameTF)
        Constants.textFieldStyle(tF: userEmailTF)
        Constants.textFieldStyle(tF: userLastNameTF)
        Constants.textFieldStyle(tF: userPhoneTF)
        
        uiViewStyle.layer.borderWidth = 1
        uiViewStyle.layer.cornerRadius = 10
        uiViewStyle.layer.borderColor = UIColor.gray.cgColor
        
        appBarView.secoundTrailingIcon.isHidden = true
        appBarView.trailingIcon.setImage(UIImage(named:"icons8-edit-35"), for: .normal)
        
        appBarView.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        appBarView.trailingIcon.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        appBarView.lableTitle.text = "Personal Details"
        
        profileImageView.editPicBtn.addTarget(self, action: #selector(editImageTapped), for: .touchUpInside)
        
        enableEditting(isEnable: isEditing)

    }
    @objc func editImageTapped(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func editButtonTapped(){
        isEditing = !isEditing
        isEditing ? appBarView.trailingIcon.setImage(UIImage(named: "icons8-done-35"), for: .normal) : appBarView.trailingIcon.setImage(UIImage(named:"icons8-edit-35"), for: .normal)
        enableEditting(isEnable: isEditing)
        if(isEditing){
            print("Update Data")
        }
    }
    
    private func enableEditting(isEnable:Bool){
        profileImageView.editPicBtn.isHidden = !isEnable
        self.userFirstNameTF.isEnabled = isEnable
        self.userEmailTF.isEnabled = isEnable
        self.userLastNameTF.isEnabled = isEnable
        self.userPhoneTF.isEnabled = isEnable
        
        profileImageView.uploadLabel.text = isEnable ? "Upload image" : "Aya Hany"
    }
}

extension SettingsViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profileImageView.profileImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
}
