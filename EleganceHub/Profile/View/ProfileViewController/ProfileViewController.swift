//
//  ProfileViewController.swift
//  EleganceHub
//
//  Created by AYA on 02/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
    let cellData:[SettingCellModelData] = [SettingCellModelData(lableName: "Personal Details", iconName: "person_info", navigationId: "personalDetails"),SettingCellModelData(lableName: "My Orders", iconName: "orders", navigationId: "myOrders"),SettingCellModelData(lableName: "My WishLists", iconName: "fav", navigationId: "fav"),SettingCellModelData(lableName: "Shipping Address", iconName: "shipping", navigationId: "shippingAddress"),
        SettingCellModelData(lableName: "Currency", iconName: "currency", navigationId: "currency"),
         SettingCellModelData(lableName: "About Us", iconName: "aboutus", navigationId: "aboutUs")]
    
    @IBOutlet weak var customerEmailLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var settingTableView:UITableView!
    
    @IBOutlet weak var tableUIView:UIView!
    @IBOutlet weak var personUIView:UIView!
    
    @IBOutlet weak var personImage:UIImageView!
    var customerID:Int?
    
    var viewModel:CustomerDataProtocol?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commenInit()
        viewModel = SettingsViewModel()
        checkForUser()
    }
    
    private func commenInit() {
        let nibCell = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        settingTableView.register(nibCell, forCellReuseIdentifier: "ProfileTableViewCell")
        
        settingTableView.dataSource = self
        settingTableView.delegate = self
        settingTableView.separatorStyle = .none
        
        setUpViewStyle(uiViewStyle: tableUIView)
        setupShadow()
        self.personImage.layer.cornerRadius = 10
    }
    
    private func setUpViewStyle(uiViewStyle:UIView){
        uiViewStyle.layer.borderWidth = 1
        uiViewStyle.layer.cornerRadius = 10
        uiViewStyle.layer.borderColor = UIColor.gray.cgColor
    }
    private func setupShadow() {
        personUIView.layer.shadowColor = UIColor.black.cgColor
        personUIView.layer.shadowOpacity = 0.5
        personUIView.layer.shadowOffset = CGSize(width: 0, height: 2)
        personUIView.layer.shadowRadius = 4
        personUIView.layer.cornerRadius = 10
    }

    
    private func checkForUser(){
        bindUserData()
        onErrorObserverSetUp()
        profilePicBind()
        if(UserDefaultsHelper.shared.isLoggedIn()){
            customerID = UserDefaultsHelper.shared.getLoggedInUserID()
            guard let id = customerID else {return}
            getUserData(id:id)
        }
    }
    private func getUserData(id:Int){
        viewModel?.loadUSerData(customerID: id)
    }
    private func bindUserData(){
        viewModel?.customerResponse
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                if let response = response.customer {
                    Constants.displayToast(viewController: self, message: "data downloaded Successfully", seconds: 2.0)
                    self.updateUI(user: response)
                }
            })
            .disposed(by: disposeBag)
    }
    private func onErrorObserverSetUp(){
        viewModel?.error.subscribe{ err in
            Constants.displayAlert(viewController: self,message: err.error?.localizedDescription as? String ?? "Failed to get data", seconds: 3)
        }.disposed(by: disposeBag)
    }
    private func updateUI(user: Customer){
        customerEmailLabel.text = user.email
        customerNameLabel.text = user.firstName
        
    }
    private func profilePicBind(){
        viewModel?.loadImage()
        if let img = viewModel?.savedImage {
            personImage.image = img
        }
    }

}

extension ProfileViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
            cell.cellIcon.image = UIImage(named: cellData[indexPath.row].iconName)
            cell.cellLable.text = cellData[indexPath.row].lableName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(UserDefaultsHelper.shared.isLoggedIn()){
            switch(cellData[indexPath.row].navigationId){
            case "currency":
                let alertController = UIAlertController(title: "Select Currency", message: nil, preferredStyle: .actionSheet)
                let currencies = ["USD", "EGP", "EUR"]
                for currency in currencies {
                    let action = UIAlertAction(title: currency, style: .default) { _ in
                        UserDefaultsHelper.shared.saveCurrencyToUserDefaults(coin: currency)
                    }
                    alertController.addAction(action)
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion: nil)
                
            case "personalDetails":
                let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
                self.navigationController?.pushViewController(viewController!, animated: true)
            case "shippingAddress":
                self.navigationController?.pushViewController(ShippingAddressViewController(), animated: true)
            case "myOrders":
                
                let OrdersViewController =  self.storyboard?.instantiateViewController(withIdentifier: "OrdersViewController") as? OrdersViewController
                self.navigationController?.pushViewController(OrdersViewController!, animated: true)
            case "fav":
                if let favoriteViewController = storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as? FavoriteViewController {
                        navigationController?.pushViewController(favoriteViewController, animated: true)
                } else {
                    print("Failed to instantiate FavoriteViewController")
                }
            case "aboutUs":
                guard let aboutUsViewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController")
                  else { return
                    print("Failed to instantiate FavoriteViewController")
                }
                navigationController?.pushViewController(aboutUsViewController, animated: true)
            default: break
                
            }
            settingTableView.deselectRow(at: indexPath, animated: true)
        }else{
            settingTableView.deselectRow(at: indexPath, animated: true)
            Constants.showLoginAlert(on: self)
        }
    }
    
}


