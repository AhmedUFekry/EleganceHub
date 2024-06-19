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
    
    @IBOutlet weak var totaldraftPriceLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryCallingLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var cityAddressLabel: UILabel!
    @IBOutlet weak var streetAddressLabel: UILabel!
   
    @IBOutlet weak var copunTextField: UITextField!
    @IBOutlet weak var validateBtn: UIButton!
    
    @IBOutlet weak var productItemTableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var promoCodeView: UIView!
    @IBOutlet weak var adressView: UIView!
    var viewModel:CartViewModelProtocol = CartViewModel()
    
    var draftOrderID: Int?
    var currencyViewModel = CurrencyViewModel()
    var rate : Double!
    let userCurrency = UserDefaultsHelper.shared.getCurrencyFromUserDefaults().uppercased()
    
    @IBAction func placeOrderButton(_ sender: UIButton) {
        //let storyBoard = UIStoryboard(name: "Main", bundle: <#T##Bundle?#>)
        let vc = (self.storyboard?.instantiateViewController(identifier: "PaymentViewController"))! as PaymentViewController
        //vc.draftOrder = self.draftOrder
        vc.draftOrder = self.draftOrder
        self.navigationController?.pushViewController(vc, animated: true)

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
    override func viewDidAppear(_ animated: Bool) {
        fetchDraftOrder()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeOnResponse()
        loadingObserverSetUp()
        onErrorObserverSetUp()
    }
 
    private func setupUI() {
        let productsNibCell = UINib(nibName: "ProductsTableViewCell", bundle: nil)
        productItemTableView.register(productsNibCell, forCellReuseIdentifier: "productOrderCell")
        productItemTableView.delegate = self
        productItemTableView.dataSource = self
        productItemTableView.allowsSelection = false
        adressView.applyShadow()
        promoCodeView.applyShadow()
        backBtn.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func fetchDraftOrder() {
        draftOrderID = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.getDraftOrder.rawValue)
        guard let id = draftOrderID else {return}

        if draftOrderID != 0{
            viewModel.getDraftOrderForUser(orderID: id)
        }
    }
    private func observeOnResponse() {
        viewModel.draftOrder
            .subscribe(onNext: { [weak self] draftOrder in
                guard let self = self else { return }
                self.draftOrder = draftOrder
                self.renderView()
            }, onError: { [weak self] error in
                guard let self = self else { return }
                Constants.displayToast(viewController: self, message: error.localizedDescription, seconds: 2.0)
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
            var convertedPrice = convertPrice(price: self.draftOrder?.totalPrice ?? "2", rate: self.rate)
            self.totaldraftPriceLabel.text = "\(String(format: "%.2f", convertedPrice)) \(self.userCurrency)"
            self.streetAddressLabel.text = self.draftOrder?.shippingAddress?.address1
            self.cityAddressLabel.text = self.draftOrder?.shippingAddress?.city
            self.phoneLabel.text = self.draftOrder?.shippingAddress?.phone
            self.zipCodeLabel.text = self.draftOrder?.shippingAddress?.zip
            self.countryCallingLabel.text = self.draftOrder?.shippingAddress?.countryCode
            self.countryLabel.text = self.draftOrder?.shippingAddress?.country
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func validateCopunBtn(_ sender: UIButton) {
        let code = self.copunTextField.text
        if let code = self.copunTextField.text {
            viewModel.checkForCopuns(copunsString: code, draftOrder: draftOrder!)
        }else{
            Constants.displayToast(viewController: self, message: "There is no Code", seconds: 2.0)
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
        return 110
    }
}
