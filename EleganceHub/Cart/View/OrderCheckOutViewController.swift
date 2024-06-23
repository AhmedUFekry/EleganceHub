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
    var disposeBag = DisposeBag()
    let isDarkMode = UserDefaultsHelper.shared.isDarkMode()
    var oldDraftOrder:DraftOrder?
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var totaldraftPriceLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var copunTextField: UITextField!
    @IBOutlet weak var validateBtn: UIButton!
    @IBOutlet weak var appBar: CustomAppBarUIView!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var productItemTableView: UITableView!
    @IBOutlet weak var promoCodeView: UIView!
    @IBOutlet weak var productsView: UIView!

    var viewModel = CartViewModel()
    
    var draftOrderID: Int?
    var currencyViewModel = CurrencyViewModel()
    var rate : Double = UserDefaultsHelper.shared.getDataDoubleFound(key: UserDefaultsConstants.currencyRate.rawValue)
    let userCurrency:String = UserDefaultsHelper.shared.getCurrencyFromUserDefaults().uppercased()
    
    @IBAction func placeOrderButton(_ sender: UIButton) {
        let vc = (self.storyboard?.instantiateViewController(identifier: "PaymentViewController"))! as PaymentViewController
        //vc.draftOrder = self.draftOrder
        vc.draftOrder = self.draftOrder
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.startAnimating()
        setupUI()
        setUpStyle()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        observeOnResponse()
        loadingObserverSetUp()
        onErrorObserverSetUp()
        fetchDraftOrder()
        
        if isDarkMode{
            appBar.trailingIcon.setImage(UIImage(named: "add"), for: .normal)
        }else{
            appBar.trailingIcon.setImage(UIImage(named: "add-Light"), for: .normal)
        }
    }
 
    private func setupUI() {
        let productsNibCell = UINib(nibName: "ProductsTableViewCell", bundle: nil)
        productItemTableView.register(productsNibCell, forCellReuseIdentifier: "productOrderCell")
        productItemTableView.delegate = self
        productItemTableView.dataSource = self
        productItemTableView.allowsSelection = false
        productItemTableView.separatorStyle = .none
        
        appBar.secoundTrailingIcon.isHidden = true
        appBar.lableTitle.text = "Order Details"
        appBar.trailingIcon.isHidden = true
        appBar.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpStyle()
    }
    private func setUpStyle(){
        Utilities.setUpViewStyle(uiViewStyle: priceView)
        Utilities.setUpViewStyle(uiViewStyle: productsView)
        promoCodeView.applyShadow()
    }
    private func fetchDraftOrder() {
        draftOrderID = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.getDraftOrder.rawValue)
        guard let id = draftOrderID else {return}

        if draftOrderID != 0{
            viewModel.getDraftOrderForUser(orderID: id)
        }
    }
    @objc func goBack() {
        guard let draftOrderID = self.draftOrderID , let draftOrder = self.oldDraftOrder else{
            self.navigationController?.popViewController(animated: true)
            return
        }
       viewModel.updateDraftOrder(orderID: draftOrderID, draftOrder: draftOrder,qos: .background)
        print("print revert old order ")
        self.navigationController?.popViewController(animated: true)

    }
    private func observeOnResponse() {
        viewModel.draftOrder
            .subscribe(onNext: { [weak self] draftOrder in
                guard let self = self else { return }
                self.draftOrder = draftOrder
                self.renderView()
            }, onError: { [weak self] error in
                guard let self = self else { return }
                Constants.displayAlert(viewController: self, message: error.localizedDescription, seconds: 2.0)
            }).disposed(by: disposeBag)
        
        viewModel.isValiedCopoun.subscribe{ isValied in
            if isValied {
                Constants.displayAlert(viewController: self,message: "You got the discount", seconds: 1.5)
            }
            self.validateBtn.isEnabled = !isValied
            self.copunTextField.isEnabled = !isValied
        }.disposed(by: disposeBag)
    }
    
    private func loadingObserverSetUp(){
        viewModel.isLoading.subscribe{ isloading in
            self.showActivityIndicator(isloading)
        }.disposed(by: disposeBag)
    }
    private func showActivityIndicator(_ show: Bool) {
        if show {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }
    private func onErrorObserverSetUp(){
        viewModel.error.subscribe{ err in
            self.showAlertError(err: err)
            
        }.disposed(by: disposeBag)
    }
    private func showAlertError(err:Error){
        switch err {
        case MyError.errorAtCopuns:
            Constants.displayAlert(viewController: self,message: "not valid Copoun", seconds: 2)
            self.copunTextField.layer.borderColor = UIColor.red.cgColor
        default:
            Constants.displayAlert(viewController: self,message: err.localizedDescription, seconds: 2)
        }
        
    }
    func renderView() {
        DispatchQueue.main.async {
            self.productItemTableView.reloadData()
            let convertedTotalPrice = convertPrice(price: self.draftOrder?.totalPrice ?? "1", rate: self.rate)
            let convertedSubTotalPrice = convertPrice(price: self.draftOrder?.subtotalPrice ?? "1", rate: self.rate)
            let convertedTaxPrice = convertPrice(price: self.draftOrder?.totalTax ?? "1", rate: self.rate)
            self.totaldraftPriceLabel.text = "\(String(format: "%.2f", convertedTotalPrice)) \(self.userCurrency)"
            self.subTotalLabel.text = "\(String(format: "%.2f", convertedSubTotalPrice)) \(self.userCurrency)"
            self.shippingLabel.text = "\(String(format: "%.2f", convertedTaxPrice)) \(self.userCurrency)"
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func validateCopunBtn(_ sender: UIButton) {
        let code = self.copunTextField.text
        if let code = self.copunTextField.text {
            oldDraftOrder = draftOrder
            viewModel.checkForCopuns(copunsString: code, draftOrder: draftOrder!)
        }else{
            Constants.displayAlert(viewController: self, message: "There is no Code", seconds: 2.0)
        }
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
        return 120
    }
}
