//
//  OrdersViewController.swift
//  EleganceHub
//
//  Created by raneem on 08/06/2024.
//

import UIKit

class OrdersViewController: UIViewController {
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    @IBOutlet weak var placeHolder: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var appBar: CustomAppBarUIView!
    
    var orders: [Order]?
        var ordersViewModel = OrdersViewModel(orderService: OrdersService())
        var selectedOrder: Order?
        var currencyViewModel = CurrencyViewModel()
        var rate: Double!
        let userCurrency = UserDefaultsHelper.shared.getCurrencyFromUserDefaults().uppercased()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            currencyViewModel.rateClosure = { [weak self] rate in
                DispatchQueue.main.async {
                    self?.rate = rate
                }
            }
            currencyViewModel.getRate()
            isFavEmpty()
            activityIndicator.startAnimating()
            appBar.lableTitle.text = "Orders"
            appBar.secoundTrailingIcon.isHidden = true
            appBar.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
            
            let ordersNibCell = UINib(nibName: "OrdersCell", bundle: nil)
            ordersTableView.register(ordersNibCell, forCellReuseIdentifier: "OrdersCell")
            
            ordersViewModel.bindResultToViewController = { [weak self] in
                guard let self = self else { return }
                self.orders = self.ordersViewModel.viewModelresult
                self.renderView()
            }
            ordersViewModel.getOrders(customerId: "\(UserDefaultsHelper.shared.getLoggedInUserID()!)")
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            ordersViewModel.getOrders(customerId: "\(UserDefaultsHelper.shared.getLoggedInUserID()!)")
            isFavEmpty()
        }
        
        @objc func goBack() {
            self.navigationController?.popViewController(animated: true)
        }
        
        func renderView() {
            DispatchQueue.main.async {
                self.ordersTableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.isFavEmpty()
            }
        }
        
        func deleteOrder(orderId: Int) {
            self.ordersViewModel.deleteOrder(orderId: orderId)
            self.ordersViewModel.bindingOrderDelete = { [weak self] in
                DispatchQueue.main.async {
                    if self?.ordersViewModel.observableDeleteOrder == 200 {
                        print("Deleted successfully")
                    } else {
                        print("Failed to delete")
                    }
                }
            }
        }
        
        func isFavEmpty() {
            if let orders = self.orders, orders.isEmpty {
                self.ordersTableView.isHidden = true
                self.placeHolder.isHidden = false
                self.placeHolderLabel.isHidden = false
            } else {
                self.ordersTableView.isHidden = false
                self.placeHolder.isHidden = true
                self.placeHolderLabel.isHidden = true

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
                
                let convertedPrice = convertPrice(price: currentOrder.currentTotalPrice ?? "2", rate: self.rate)
                ordersCell.orderPriceLabel.text = "\(String(format: "%.2f", convertedPrice)) \(userCurrency)"
            }
            return ordersCell
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
        func showDeleteConfirmationAlert(completion: @escaping (Bool) -> Void) {
            Constants.showAlertWithAction(on: self, title: "Confirm Delete", message: "Are you sure you want to delete this item?", isTwoBtn: true, firstBtnTitle: "Cancel", actionBtnTitle: "Delete", style: .destructive) { confirmed in
                completion(true)
            }
        }
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
                guard let self = self else { return }
                self.showDeleteConfirmationAlert { confirmed in
                    if confirmed {
                        guard let orderId = self.orders?[indexPath.section].id else { return }
                            self.deleteOrder(orderId: orderId)
                            self.orders?.remove(at: indexPath.section)
                            self.ordersTableView.performBatchUpdates({
                                self.ordersTableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                            }, completion: { finished in
                                self.ordersTableView.reloadData()
                                self.isFavEmpty()
                            })
                    }
                    completionHandler(confirmed)
                }
            }
        
            deleteAction.backgroundColor = UIColor(named: "btnColor") ?? .black
            let trashIcon = UIImage(systemName: "trash")?.withTintColor(UIColor(named: "theme") ?? .black, renderingMode: .alwaysOriginal)
            deleteAction.image = trashIcon

            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            configuration.performsFirstActionWithFullSwipe = false
            return configuration
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showOrderDetailSegue" {
                if let destinationVC = segue.destination as? OrderDetailsViewController {
                    destinationVC.selctedOrder = selectedOrder
                }
            }
        }
    }
  




