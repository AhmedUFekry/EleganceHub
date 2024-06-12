//
//  OrderCheckOutViewController.swift
//  EleganceHub
//
//  Created by raneem on 12/06/2024.
//

import UIKit

class OrderCheckOutViewController: UIViewController {

    @IBOutlet weak var promoCodeView: UIView!
    @IBOutlet weak var adressView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        adressView.applyShadow()
        promoCodeView.applyShadow()
    }
}
