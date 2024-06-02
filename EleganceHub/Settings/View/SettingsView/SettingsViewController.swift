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
        appBarView.trailingIcon.isHidden = true
        
        appBarView.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
   
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
}
