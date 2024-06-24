//
//  ProfileViewController.swift
//  EleganceHub
//
//  Created by AYA on 02/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController,UpdateThemaDelegate {
    let cellData:[SettingCellModelData] = [SettingCellModelData(lableName: "Personal Details", navigationId: "personalDetails"),SettingCellModelData(lableName: "My Orders", navigationId: "myOrders"),SettingCellModelData(lableName: "My WishLists",  navigationId: "fav"),SettingCellModelData(lableName: "Shipping Address", navigationId: "shippingAddress"),
        SettingCellModelData(lableName: "Currency", navigationId: "currency"),
         SettingCellModelData(lableName: "About Us", navigationId: "aboutUs")]
    
    let iconsDark = ["person_info_Light","orders-light","fav-light","shipping-light","currency-light","aboutus-light"]
    let iconsLights = ["person_info","orders","fav","shipping","currency","aboutus"]
    
    
    @IBOutlet weak var customerEmailLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var settingTableView:UITableView!
    
    @IBOutlet weak var tableUIView:UIView!
    @IBOutlet weak var personUIView:UIView!
    
    @IBOutlet weak var personImage:UIImageView!
    var customerID:Int?
    var customerData:Customer?
    
    var viewModel:CustomerDataProtocol?
    var disposeBag = DisposeBag()
    var isDarkMode:Bool = false
    
    var networkPresenter :NetworkManager?
    var isConnected:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commenInit()
        viewModel = SettingsViewModel()
        viewModel?.rateClosure = { coin in
            UserDefaultsHelper.shared.setIfDataFound(doubleData: coin, key: UserDefaultsConstants.currencyRate.rawValue)
            
            print("Data Stored at user Defaults \(coin) in \(UserDefaultsHelper.shared.getDataDoubleFound(key: UserDefaultsConstants.currencyRate.rawValue))")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkPresenter = NetworkManager(vc: self)
        isDarkMode = UserDefaultsHelper.shared.isDarkMode()
        
    }
    
    private func commenInit() {
        let nibCell = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        settingTableView.register(nibCell, forCellReuseIdentifier: "ProfileTableViewCell")
        
        settingTableView.dataSource = self
        settingTableView.delegate = self
        settingTableView.separatorStyle = .none
        
        Utilities.setUpViewStyle(uiViewStyle: tableUIView)
        personUIView.applyShadow()
        self.personImage.layer.cornerRadius = 10
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
                    self.updateUI(user: response)
                    self.customerData = response
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
    
    func updateView() {
        settingTableView.reloadData()
    }

}

extension ProfileViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        let iconName = isDarkMode ? iconsDark[indexPath.row] : iconsLights[indexPath.row]
        cell.cellIcon.image = UIImage(named: iconName)
            cell.cellLable.text = cellData[indexPath.row].lableName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let isConnected = isConnected else {return}
        if isConnected{
            if(UserDefaultsHelper.shared.isDataFound(key: UserDefaultsConstants.isLoggedIn.rawValue)){
                switch(cellData[indexPath.row].navigationId){
                case "fav":
                    if let favoriteViewController = storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as? FavoriteViewController {
                        navigationController?.pushViewController(favoriteViewController, animated: true)
                    } else {
                        print("Failed to instantiate FavoriteViewController")
                    }
                case "currency":
                    let alertController = UIAlertController(title: "Select Currency", message: nil, preferredStyle: .actionSheet)
                    let currencies = ["USD", "EGP", "EUR"]
                    for currency in currencies {
                        let action = UIAlertAction(title: currency, style: .default) { _ in
                            UserDefaultsHelper.shared.saveCurrencyToUserDefaults(coin: currency.uppercased())
                            self.viewModel?.getRate(currencyType: currency)
                        }
                        action.setValue(UIColor.label, forKey: "titleTextColor")
                        alertController.addAction(action)
                    }
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    cancelAction.setValue(UIColor.label, forKey: "titleTextColor")
                    
                    alertController.addAction(cancelAction)
                    present(alertController, animated: true, completion: nil)
                    
                case "personalDetails":
                    let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
                    guard let vc = viewController else {return}
                    if let customer = self.customerData {
                        vc.customerData = customer
                    }
                    vc.updateViewDelegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                case "shippingAddress":
                    self.navigationController?.pushViewController(ShippingAddressViewController(), animated: true)
                case "myOrders":
                    
                    let OrdersViewController =  self.storyboard?.instantiateViewController(withIdentifier: "OrdersViewController") as? OrdersViewController
                    self.navigationController?.pushViewController(OrdersViewController!, animated: true)
              
                case "aboutUs":
                    guard let aboutUsViewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController")
                    else { return
                        print("Failed to instantiate FavoriteViewController")
                    }
                    navigationController?.pushViewController(aboutUsViewController, animated: true)
                default: break
                    
                }
            }else{
                switch(cellData[indexPath.row].navigationId){
                case "aboutUs":
                    guard let aboutUsViewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController")
                    else { return
                        print("Failed to instantiate FavoriteViewController")
                    }
                    navigationController?.pushViewController(aboutUsViewController, animated: true)
                default:
                    Constants.showAlertWithAction(on: self, title: "Login Required", message: "You need to login to access this feature.", isTwoBtn: true, firstBtnTitle: "Cancel", actionBtnTitle: "Login") { [weak self] _ in
                        guard let viewController = self else { return }
                        if let newViewController = viewController.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
                            newViewController.hidesBottomBarWhenPushed = true
                            viewController.navigationController?.pushViewController(newViewController, animated: true)
                        }
                    }
                }
            }
        }else{
            switch(cellData[indexPath.row].navigationId){
            case "aboutUs":
                guard let aboutUsViewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController")
                else { return
                    print("Failed to instantiate FavoriteViewController")
                }
                navigationController?.pushViewController(aboutUsViewController, animated: true)
            case "fav":
                if let favoriteViewController = storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as? FavoriteViewController {
                    navigationController?.pushViewController(favoriteViewController, animated: true)
                } else {
                    print("Failed to instantiate FavoriteViewController")
                }
            default:
                ConnectivityUtils.showConnectivityAlert(from: self)
            }

        }
        settingTableView.deselectRow(at: indexPath, animated: true)
    }
   
}

extension ProfileViewController: ConnectivityProtocol, NetworkStatusProtocol{
    
    func networkStatusDidChange(connected: Bool) {
        isConnected = connected
        print("networkStatusDidChange called \(isConnected)")
        checkForConnection()
    }
    
    private func checkForConnection(){
        guard let isConnected = isConnected else {
            ConnectivityUtils.showConnectivityAlert(from: self)
            print("is connect nilllllll")
            return
        }
        if isConnected{
            getData()
        }else{
           // ConnectivityUtils.showConnectivityAlert(from: self)
        }
    }
    
    private func getData(){
        checkForUser()
    }
 
}
