//
//  OrdersViewController.swift
//  EleganceHub
//
//  Created by raneem on 08/06/2024.
//

import UIKit

class OrdersViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var appBar: CustomAppBarUIView!
    var orders: [Order]?
    var ordersViewModel = OrdersViewModel(orderService: OrdersService())
    var selectedOrder: Order?
    var currencyViewModel = CurrencyViewModel()
    var rate : Double!
    let userCurrency = UserDefaultsHelper.shared.getCurrencyFromUserDefaults().uppercased()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyViewModel.rateClosure = {
            [weak self] rate in
            DispatchQueue.main.async {
                self?.rate = rate
            }
        }
        currencyViewModel.getRate()
        
        activityIndicator.startAnimating()
        appBar.lableTitle.text = "Orders"
        appBar.secoundTrailingIcon.isHidden = true
        appBar.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        let ordersNibCell = UINib(nibName: "OrdersCell", bundle: nil)
        ordersTableView.register(ordersNibCell, forCellReuseIdentifier: "OrdersCell")
        
        ordersViewModel.bindResultToViewController = {
            [weak self] in
            guard let self = self else { return }
            self.orders = self.ordersViewModel.viewModelresult
            self.renderView()
        }
        ordersViewModel.getOrders(customerId:  "\(UserDefaultsHelper.shared.getLoggedInUserID()!)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ordersViewModel.getOrders(customerId:  "\(UserDefaultsHelper.shared.getLoggedInUserID()!)")
    }
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func renderView() {
        DispatchQueue.main.async {
            self.ordersTableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    
}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {
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
        if let currentOrder = orders?[indexPath.section] {
            ordersCell.orderIdLabel?.text = "\(currentOrder.customer?.id ?? 81254567)"
            ordersCell.orderDateLabel?.text = currentOrder.createdAt?.split(separator: "T").first.map(String.init)
            //ordersCell.orderPriceLabel?.text = currentOrder.currentTotalPrice
            
            var convertedPrice = convertPrice(price: currentOrder.currentTotalPrice ?? "2", rate: self.rate)
            ordersCell.orderPriceLabel.text = "\(String(format: "%.2f", convertedPrice)) \(userCurrency)"
        }
        return ordersCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOrderDetailSegue" {
            if let destinationVC = segue.destination as? OrderDetailsViewController {
                destinationVC.selctedOrder = selectedOrder
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currentOrder = orders?[indexPath.section] {
            selectedOrder = currentOrder
            performSegue(withIdentifier: "showOrderDetailSegue", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

