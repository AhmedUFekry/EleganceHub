//
//  SettingsTableView.swift
//  EleganceHub
//
//  Created by AYA on 01/06/2024.
//

import UIKit

class SettingsTableView: UIView {
    let cellData:[CellModelData] = [CellModelData(lableName: "Personal Details", iconName: "person_info", navigationId: "personalDetails"),CellModelData(lableName: "My Orders", iconName: "orders", navigationId: "myOrders"),CellModelData(lableName: "My WishLists", iconName: "fav", navigationId: "fav"),CellModelData(lableName: "Shipping Address", iconName: "shipping", navigationId: "shippingAddress"),CellModelData(lableName: "Settings", iconName: "settings", navigationId: "settings"),
         CellModelData(lableName: "About Us", iconName: "aboutus", navigationId: "aboutUs")]
    @IBOutlet weak var settingTableView:UITableView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commenInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commenInit()
    }
    
    func commenInit() {
        guard let settingTableView = settingTableView else {
                    return
                }
                
                let cartNibCell = UINib(nibName: "SettingsTableViewCell", bundle: nil)
                settingTableView.register(cartNibCell, forCellReuseIdentifier: "SettingsTableViewCell")
                
                settingTableView.backgroundColor = UIColor.red
        settingTableView.dataSource = self
        settingTableView.delegate = self
    }

}

extension SettingsTableView:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
            cell.cellIcon.image = UIImage(named: cellData[indexPath.row].iconName)
            cell.cellLable.text = cellData[indexPath.row].lableName
        return cell
    }
}

