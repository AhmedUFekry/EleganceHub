//
//  LocationViewController.swift
//  EleganceHub
//
//  Created by AYA on 02/06/2024.
//

import UIKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var cityNameLable: UILabel!
    @IBOutlet weak var countryIconLable: UILabel!
    @IBOutlet weak var countryNameLable: UILabel!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var zipCodeTF: UITextField!
    @IBOutlet weak var streetTF: UITextField!
    @IBOutlet weak var selectCityBtn : UIButton!
    @IBOutlet weak var cancelBtn : UIButton!
    
    var onSelect: ((CountryDataModel) -> Void)?
    var delegate: UpdateLocationDelegate? {
        didSet {
            print("Delegate assigned: \(delegate)")
        }
    }
    
    var settingVM:AddressesViewModelProtocol? = AddressesViewModel()
    
    var listCountry:[CountryDataModel] = []
    var listCities:[String] = []
    
    // MARK: get address data
    var selectedCountry,selectedCity,address,zip,phoneTxt,selectedCountryCode :String?
    // MARK: User Data
    var customerData:User? = User(id: 8222308237587, first_name: "shimaa", last_name: "shimo", email: "", password: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.settingVM?.configrationCountries()
        self.settingVM?.bindCountriesList = { [weak self] list in
            self?.listCountry = list
        }
        self.settingVM?.bindCitiesList = { [weak self] list in
            self?.listCities = list
            self?.selectCityBtn.isEnabled = true
        }
        
        self.settingVM?.failureResponse = { [weak self] err in
            guard let self = self else {return}
            Constants.displayAlert(viewController: self,message: err, seconds: 3)
        }
    }
    
    private func setup(){
        
        Constants.textFieldStyle(tF: phoneTF)
        Constants.textFieldStyle(tF: zipCodeTF)
        Constants.textFieldStyle(tF: streetTF)
        
        self.selectCityBtn.isEnabled = false
        
        cancelBtn.layer.borderWidth = 2.0
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.cornerRadius = 10
    }
    
    @IBAction func pickCountryBtn(_ sender: UIButton) {
        let customAlert = CustomAlertViewController()
        customAlert.alertTitle = "Choose Country"
        customAlert.pickerData = listCountry
        customAlert.onSelect = { [weak self] isSelected, selectedItem in
                if isSelected {
                    print("Select button tapped")
                    if let selectedItem = selectedItem as? CountryDataModel {
                            print("Selected item: \(selectedItem)")
                        self?.countryNameLable.text = selectedItem.countryName
                        self?.settingVM?.getCitiesOfSelectedCountry(selectedCountry:  selectedItem.countryName ?? "Egypt" )
                        self?.selectedCountry = selectedItem.countryName
                        self?.selectedCountryCode = selectedItem.extensionCode
                        self?.countryIconLable.text = selectedItem.flag
                    }
                    
                } else {
                    print("Cancel button tapped")
                }
            }
        customAlert.show(from: self)
        
    }
    
    @IBAction func pickCityBtn(_ sender: UIButton) {
        
        let customAlert = CustomAlertViewController()
        customAlert.alertTitle = "Choose City"
        customAlert.pickerData = listCities
        customAlert.onSelect = { [weak self] isSelected, selectedItem in
            if isSelected {
                print("Select button tapped")
                if let selectedItem = selectedItem as? String{
                    self?.cityNameLable.text = selectedItem
                    self?.selectedCity = selectedItem
                }
                
            } else {
                print("Cancel button tapped")
            }
        }
        customAlert.show(from: self)
        
    }
    
    @IBAction func addLocationBtn(_ sender: UIButton) {
        
        if let selectedCountry = selectedCountry,
           let selectedCity = selectedCity,
           let selectedCountryCode = selectedCountryCode,
           let address = streetTF.text, !address.isEmpty,
           let phoneTxt = phoneTF.text, !phoneTxt.isEmpty,
           let zip = zipCodeTF.text, !zip.isEmpty {
            print("not nill data")
            var userAdress = AddressData(address1: address, address2: "", city: selectedCity, company: "", firstName: customerData?.first_name, lastName: customerData?.last_name, phone: phoneTxt, province: "", country: selectedCountry, zip: zip, name: "\(customerData!.first_name!) \(customerData!.last_name!)", provinceCode: "", countryCode: selectedCountryCode, countryName: selectedCountry)
            self.settingVM?.addNewAddress(customerID: customerData!.id!, addressData: userAdress)
            self.dismiss(animated: true) {
                self.delegate?.didAddNewAddress()
            }

        self.dismiss(animated: true, completion: nil)
                }else{
                    Constants.displayAlert(viewController:self,message: "Please enter your data", seconds: 3.0)
        }
    }
    @IBAction func cancelBtnTapped(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    
    
    
}

