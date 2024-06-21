//
//  AddressesTableViewCell.swift
//  EleganceHub
//
//  Created by AYA on 02/06/2024.
//

import UIKit

class AddressesTableViewCell: UITableViewCell {
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContent.applyShadow()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCellData(address:Address) {
        streetLabel.text = address.address1
        cityLabel.text = address.city
        countryLabel.text = address.country
        phoneNumberLabel.text = address.phone
        zipcodeLabel.text = address.zip
        countryCodeLabel.text = address.countryCode
    }
    func setiii(p:String){
        print(p)
    }
}
//city: address.city, street: address.address1, country: address.country, code: address.countryCode, zip: address.zip, phone: address.phone
