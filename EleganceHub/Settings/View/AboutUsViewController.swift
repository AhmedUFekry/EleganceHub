//
//  AboutUsViewController.swift
//  EleganceHub
//
//  Created by AYA on 18/06/2024.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var appBarView:CustomAppBarUIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        appBarView.secoundTrailingIcon.isHidden = true
        
        appBarView.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        appBarView.trailingIcon.isHidden = true
        
        appBarView.lableTitle.text = "About us"
        
    }
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
