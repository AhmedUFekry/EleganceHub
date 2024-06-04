//
//  CustomAlertViewController.swift
//  EleganceHub
//
//  Created by AYA on 04/06/2024.
//

import UIKit

class CustomAlertViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var viewPicker: UIPickerView!
    @IBOutlet weak var viewAlert: UIView!
    
    var alertTitle:String? = "Choose"
    var onSelect: ((Bool, Any?) -> Void)?
    var pickerData: [Any] = []
    var selectedPickerItem: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpData()
        
        viewPicker.delegate = self
        viewPicker.dataSource = self
        if !pickerData.isEmpty{
            selectedPickerItem = self.pickerData[0]
        }
    }
    
    init() {
        super.init(nibName: "CustomAlertViewController", bundle: Bundle(for: CustomAlertViewController.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func show(from viewController: UIViewController) {
        viewController.present(self, animated: true, completion: nil)
    }

    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func selectBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        onSelect?(true, selectedPickerItem)
        
    }
    
    func setUpData(){
        cancelBtn.layer.borderWidth = 2.0
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        cancelBtn.layer.cornerRadius = 10
        viewAlert.layer.shadowColor = UIColor.black.cgColor
        viewAlert.layer.shadowOpacity = 0.5
        viewAlert.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewAlert.layer.shadowRadius = 4
        viewAlert.layer.cornerRadius = 10
        
        titleLabel.text = alertTitle
        
    }

}

extension CustomAlertViewController:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //self.settingVM?.listOfCountries?.count ?? 0
        if pickerData.isEmpty{
            return 1
        }else{
            return self.pickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
        {
            return 60
        }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
        {
            let countryItemView = CountryItemView()
            if(!pickerData.isEmpty){
                if let countryData = pickerData[row] as? CountryDataModel {
                    countryItemView.countryNameLable
                        .text = countryData.countryName
                    countryItemView.countryIcon.text = countryData.flag ?? ""
                } else if let cityName = pickerData[row] as? String {
                    countryItemView.countryNameLable.text = cityName
                    countryItemView.countryIcon.isHidden = true
                }
            }else {
                countryItemView.countryNameLable.text = "No Cities Avilable"
                countryItemView.countryIcon.isHidden = true
            
            }
                return countryItemView
        }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(!pickerData.isEmpty){
            selectedPickerItem = pickerData[row]
        }
    }
    
}
