//
//  ProfileViewController.swift
//  EleganceHub
//
//  Created by AYA on 02/06/2024.
//

import UIKit

class ProfileViewController: UIViewController {
    let cellData:[SettingCellModelData] = [SettingCellModelData(lableName: "Personal Details", iconName: "person_info", navigationId: "personalDetails"),SettingCellModelData(lableName: "My Orders", iconName: "orders", navigationId: "myOrders"),SettingCellModelData(lableName: "My WishLists", iconName: "fav", navigationId: "fav"),SettingCellModelData(lableName: "Shipping Address", iconName: "shipping", navigationId: "shippingAddress"),
        SettingCellModelData(lableName: "Currency", iconName: "currency", navigationId: "currency"),SettingCellModelData(lableName: "Settings", iconName: "settings", navigationId: "settings"),
         SettingCellModelData(lableName: "About Us", iconName: "aboutus", navigationId: "aboutUs")]
    
    @IBOutlet weak var settingTableView:UITableView!
    
    @IBOutlet weak var tableUIView:UIView!
    @IBOutlet weak var personUIView:UIView!
    
    @IBOutlet weak var personImage:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commenInit()
    }
    
    private func commenInit() {
        let nibCell = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        settingTableView.register(nibCell, forCellReuseIdentifier: "ProfileTableViewCell")
        //let cartNibCell = UINib(nibName: "CartTableViewCell", bundle: nil)
        //settingTableView.register(cartNibCell, forCellReuseIdentifier: "CartTableViewCell")
        
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
        personUIView.layer.shadowPath = UIBezierPath(roundedRect: self.personUIView.bounds, cornerRadius: self.personUIView.layer.cornerRadius).cgPath
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
        switch(cellData[indexPath.row].navigationId){
            case "personalDetails":
                let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
                self.navigationController?.pushViewController(viewController!, animated: true)
        case "shippingAddress":
            self.navigationController?.pushViewController(ShippingAddressViewController(), animated: true)
            
        default: break
            
        }
        settingTableView.deselectRow(at: indexPath, animated: true)
    }
    
}


