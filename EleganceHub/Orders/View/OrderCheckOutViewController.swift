//
//  OrderCheckOutViewController.swift
//  EleganceHub
//
//  Created by raneem on 12/06/2024.
//

import UIKit
import RxSwift

class OrderCheckOutViewController: UIViewController {
    var selectedAddress: Address?
    var draftOrder : DraftOrder?
    
    @IBOutlet weak var totaldraftPriceLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryCallingLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var cityAddressLabel: UILabel!
    @IBOutlet weak var streetAddressLabel: UILabel!
   
    @IBOutlet weak var productItemTableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var promoCodeView: UIView!
    @IBOutlet weak var adressView: UIView!
    var currencyViewModel = CurrencyViewModel()
    var rate : Double!
    let userCurrency = UserDefaultsHelper.shared.getCurrencyFromUserDefaults().uppercased()

    var ordersViewModel = OrdersViewModel(orderService: OrdersService())
    var viewModel: CartViewModelProtocol = CartViewModel()
    var draftOrderID: Int?
    
    @IBAction func placeOrderButton(_ sender: UIButton) {
        draftOrderID = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.getDraftOrder.rawValue)
            guard let orderID = draftOrderID else {return}
            ordersViewModel.completeDraftOrder(orderID: orderID) { [weak self] success, error in if success {
                    self?.viewModel.deleteDraftOrder(orderID: orderID)
                } else {
                    print("Failed to complete draft order: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            
            currencyViewModel.rateClosure = {
                [weak self] rate in
                DispatchQueue.main.async {
                    self?.rate = rate
                    self?.renderView()
                }
            }
            currencyViewModel.getRate()
        
        self.activityIndicator.startAnimating()
        
        setupUI()
        fetchDraftOrder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupUI() {
        let productsNibCell = UINib(nibName: "ProductsTableViewCell", bundle: nil)
        productItemTableView.register(productsNibCell, forCellReuseIdentifier: "productOrderCell")
        productItemTableView.delegate = self
        productItemTableView.dataSource = self
        adressView.applyShadow()
        promoCodeView.applyShadow()
        backBtn.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func fetchDraftOrder() {
        draftOrderID = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.getDraftOrder.rawValue)
        
        ordersViewModel.bindDraftOrder = {
            [weak self] in
            guard let self = self else { return }
            self.draftOrder = ordersViewModel.draftOrderitems
            self.renderView()
        }
        ordersViewModel.getOrderForCustomer(orderID: draftOrderID ?? 0)
        
    }
    
    func renderView() {
        DispatchQueue.main.async {
            self.productItemTableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.productItemTableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            var convertedPrice = convertPrice(price: self.draftOrder?.totalPrice ?? "2", rate: self.rate)
            self.totaldraftPriceLabel.text = "\(String(format: "%.2f", convertedPrice)) \(self.userCurrency)"
          //  self.totaldraftPriceLabel.text = self.draftOrder?.totalPrice
            self.streetAddressLabel.text = self.selectedAddress?.address1
            self.cityAddressLabel.text = self.selectedAddress?.city
            self.phoneLabel.text = self.selectedAddress?.phone
            self.zipCodeLabel.text = self.selectedAddress?.zip
            self.countryCallingLabel.text = self.selectedAddress?.countryCode
            self.countryLabel.text = self.selectedAddress?.country
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension OrderCheckOutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = draftOrder?.lineItems?.count ?? 0
        print("Number of sections: \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productsCell = tableView.dequeueReusableCell(withIdentifier: "productOrderCell", for: indexPath) as! ProductsTableViewCell
        if let lineItem = draftOrder?.lineItems?[indexPath.section] {
            productsCell.setCellUI(product: lineItem)
        }
        return productsCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
