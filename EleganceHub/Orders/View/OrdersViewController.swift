//
//  OrdersViewController.swift
//  EleganceHub
//
//  Created by raneem on 08/06/2024.
//

import UIKit

class OrdersViewController: UIViewController {
    
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var appBar: CustomAppBarUIView!
    var orders : [Order]?
    var ordersViewModel = OrdersViewModel(orderService: OrdersService())
    override func viewDidLoad() {
        super.viewDidLoad()
        appBar.lableTitle.text = "Orders"
        appBar.secoundTrailingIcon.isHidden = true
        appBar.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        let ordersNibCell = UINib(nibName: "OrdersCell", bundle: nil)
        ordersTableView.register(ordersNibCell, forCellReuseIdentifier: "OrdersCell")
        
        ordersViewModel.bindResultToViewController = {
            [weak self] in
            guard let self = self else {return}
            self.orders = self.ordersViewModel.viewModelresult
            self.renderView()
        }
        ordersViewModel.getOrders(customerId:"8229959500051") //"\(UserDefaultsHelper.shared.getLoggedInUserID())")
        
       
    }
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    func renderView() {
        DispatchQueue.main.async {
            self.ordersTableView.reloadData()
        }
    }
}
extension OrdersViewController : UITableViewDelegate ,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = orders?.count ?? 0
        print("Number of sections: \(count)")
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ordersCell = tableView.dequeueReusableCell(withIdentifier: "OrdersCell", for: indexPath) as! OrdersCell
        if let orders = orders?[indexPath.section] {
            ordersCell.orderIdLabel?.text = "\(orders.id!)"
            ordersCell.orderDateLabel?.text = "\( orders.createdAt?.split(separator: "T").first)"
            //ordersCell.orderPriceLabel?.text = orders.subtotalPrice
        }
        return ordersCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
