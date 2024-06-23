//
//  LocationViewController.swift
//  EleganceHub
//
//  Created by AYA on 02/06/2024.
//

import UIKit
import RxSwift

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
    
    var viewModel:CustomerDataProtocol?
    var disposeBag = DisposeBag()
    
    var listCountry:[CountryDataModel] = []
    var listCities:[String] = []
    
    // MARK: get address data
    var selectedCountry,selectedCity,address,zip,phoneTxt,selectedCountryCode :String?
    // MARK: User Data
    var customerData:Customer?
    var customerID:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        customerID = UserDefaultsHelper.shared.getLoggedInUserID()
        getUserData()
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
    
    private func getUserData(){
        viewModel?.loadUSerData(customerID: customerID!)
        bindUserData()
    }
    private func bindUserData(){
        viewModel?.customerResponse
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if let response = response.customer {
                    self.customerData = response
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setup(){
        setupTextFields()
        self.selectCityBtn.isEnabled = false
        
        cancelBtn.layer.borderWidth = 2.0
        cancelBtn.layer.borderColor = UIColor(named: "btnColor")?.cgColor ?? UIColor.black.cgColor
        cancelBtn.layer.cornerRadius = 10
    }
    private func setupTextFields(){
        Constants.textFieldStyle(tF: phoneTF)
        Constants.textFieldStyle(tF: zipCodeTF)
        Constants.textFieldStyle(tF: streetTF)
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
                        print("selectedCountryCode \(selectedItem.extensionCode) ")
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
            guard isValidPhone(phoneTxt) else {
                Constants.displayAlert(viewController: self, message: "Enter Valid Phone", seconds: 1.75)
                return
            }
            var userAdress = AddressData(address1: address, address2: "", city: selectedCity, company: "", firstName: customerData?.firstName, lastName: customerData?.lastName, phone: phoneTxt, province: "", country: selectedCountry, zip: zip, name: "\(customerData?.firstName!) \(customerData?.lastName!)", provinceCode: "", countryCode: selectedCountryCode, countryName: selectedCountry)
            print("selectedCountryCode \(selectedCountryCode) ")
            self.settingVM?.addNewAddress(customerID: customerID!, addressData: userAdress)
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
    private func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = "^01[0-2][0-9]{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTextFields()
    }
    
}

