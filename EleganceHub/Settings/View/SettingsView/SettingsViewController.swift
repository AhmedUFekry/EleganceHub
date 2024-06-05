//
//  SettingsViewController.swift
//  EleganceHub
//
//  Created by AYA on 25/05/2024.
//

import UIKit

class SettingsViewController: UIViewController {
    
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userEmailTF: UITextField!
    @IBOutlet weak var appBarView:CustomAppBarUIView!
    @IBOutlet weak var profileImageView:ProfileImageUIView!
    @IBOutlet weak var logOutBtn:UIButton!
    @IBOutlet weak var uiViewStyle:UIView!
    var isEditingTapped: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uISetUp()
    }
    private func uISetUp(){
        Constants.textFieldStyle(tF: userNameTF)
        Constants.textFieldStyle(tF: userEmailTF)
        uiViewStyle.layer.borderWidth = 1
        uiViewStyle.layer.cornerRadius = 10
        uiViewStyle.layer.borderColor = UIColor.gray.cgColor
        
        appBarView.secoundTrailingIcon.isHidden = true
        appBarView.trailingIcon.setImage(UIImage(named:"icons8-edit-35"), for: .normal)
        
        appBarView.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        appBarView.trailingIcon.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        appBarView.lableTitle.text = "Personal Details"
        
        profileImageView.editPicBtn.addTarget(self, action: #selector(editImageTapped), for: .touchUpInside)
        
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
    }
    private func enableEditting(isEnable:Bool){
        profileImageView.editPicBtn.isHidden = isEnable
        self.userNameTF.isEnabled = isEnable
        self.userEmailTF.isEnabled = isEnable
    }
}

extension SettingsViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profileImageView.profileImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
}
