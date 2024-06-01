//
//  SettingsViewController.swift
//  EleganceHub
//
//  Created by AYA on 25/05/2024.
//

import UIKit

class SettingsViewController: UIViewController {
    private let bottomBorder = CALayer()
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userEmailTF: UITextField!
    @IBOutlet weak var appBarView:CustomAppBarUIView!
    @IBOutlet weak var profileImageView:ProfileImageUIView!
    @IBOutlet weak var logOutBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomBorder.frame = CGRect(x: 0, y: userNameTF.frame.size.height - 1, width: userNameTF.frame.size.width, height: 1)
        bottomBorder.backgroundColor = UIColor.gray.cgColor
        userNameTF.layer.addSublayer(bottomBorder)
        userNameTF.layer.masksToBounds = true
    }
}
