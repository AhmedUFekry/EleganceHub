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
    
    let screenWidth = UIScreen.main.bounds.width - 10
        let screenHeight = UIScreen.main.bounds.height / 2
        var selectedRow = 0
    
    
    
    var settingVM:SettingsViewModelProtocol? = SettingsViewModel()
    
    var listCountry:[CountryDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Constants.textFieldStyle(tF: phoneTF)
        Constants.textFieldStyle(tF: zipCodeTF)
        Constants.textFieldStyle(tF: streetTF)
        self.settingVM?.configrationCountries()
        //listCountry = settingVM?.listOfCountries ?? []
        self.settingVM?.bindCountriesList = { list in
            self.listCountry = list
        }
        
    }

    @IBAction func pickCountryBtn(_ sender: UIButton) {
        //self.settingVM?.configrationCountries()
        
        //listCountry = settingVM?.listOfCountries ?? []
        let vc = UIViewController()
                vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
                let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:screenHeight))
                pickerView.dataSource = self
                pickerView.delegate = self
        
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(pickerView)
                pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
                pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
                
                let alert = UIAlertController(title: "Select Country", message: "", preferredStyle: .actionSheet)
                
                
                alert.setValue(vc, forKey: "contentViewController")
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel button tapped")
        }

        alert.addAction(cancelAction)
        let selectAction = UIAlertAction(title: "Select", style: .default) { (action) in
            print("selected button tapped")
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            let selected = self.listCountry[self.selectedRow]
            self.countryNameLable.text = selected.countryName
            self.countryIconLable.text = selected.flag
        }
        
        alert.addAction(selectAction)
        
        print("list country count is \(listCountry.count)")
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func pickCityBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func addLocationBtn(_ sender: UIButton) {
    }
    

}

extension LocationViewController:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //self.settingVM?.listOfCountries?.count ?? 0
        self.listCountry.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
        {
            return 60
        }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
        {
            let label = CountryItemView()
      
            label.countryNameLable.text = self.listCountry[row].countryName
            label.countryIcon.text = self.listCountry[row].flag!
            return label
        }
    
}
