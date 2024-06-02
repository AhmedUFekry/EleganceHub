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
        textFieldStyle(tF: userNameTF)
        textFieldStyle(tF: userEmailTF)
        uiViewStyle.layer.borderWidth = 1
        uiViewStyle.layer.cornerRadius = 10
        uiViewStyle.layer.borderColor = UIColor.gray.cgColor
        
        appBarView.secoundTrailingIcon.isHidden = true
        appBarView.trailingIcon.isHidden = true
        
        appBarView.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    private func textFieldStyle(tF:UITextField){
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: tF.frame.size.height - 1, width: tF.frame.size.width, height: 1)
        bottomBorder.backgroundColor = UIColor.gray.cgColor
        tF.layer.addSublayer(bottomBorder)
        tF.layer.masksToBounds = true
    }
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
}
