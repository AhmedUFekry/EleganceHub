//
//  PaymentViewController.swift
//  EleganceHub
//
//  Created by AYA on 25/05/2024.
//

import UIKit
import PassKit
import RxSwift

class PaymentViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var appBarView: CustomAppBarUIView!
    let isDarkMode = UserDefaultsHelper.shared.isDarkMode()
    
    
    let paymentList:[PaymentMethodModel] = [/*PaymentMethodModel(paymentMethod: "Credit Card", imageName: "CreditCard",id:PaymentMethod.creditCart),*/PaymentMethodModel(paymentMethod: "Apple Pay", imageName: "applePayDark",id:PaymentMethod.applePay),/*PaymentMethodModel(paymentMethod: "Paypal", imageName: "Paypal",id:PaymentMethod.payPal),*/PaymentMethodModel(paymentMethod: "Cash on delivery", imageName: "cashOnDelivery",id:PaymentMethod.cash)]
    
    var selectedMethod:PaymentMethodModel?
    var viewModel = PaymentViewModel(networkService: PaymentNetworkService())
    
    var orderID:Int?
    var draftOrder:DraftOrder?
    let disposeBag = DisposeBag()
    let userCurrency = UserDefaultsHelper.shared.getCurrencyFromUserDefaults().uppercased()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       let paymentNibCell = UINib(nibName: "PaymentMethodTableViewCell", bundle: nil)
        tableView.register(paymentNibCell, forCellReuseIdentifier: "PaymentMethodTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        appBarView.backBtn.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appBarView.lableTitle.isHidden = true
        appBarView.trailingIcon.isHidden = true
        appBarView.secoundTrailingIcon.isHidden = true
        observeOnOrder()
        loadingObserverSetUp()
        appBarView.setUpBtnsThemes()
    }
    @objc func backButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func countinueToPaymentTapped(_ sender: UIButton){
        guard let selectedMethod = selectedMethod else {
            showAlert(msg: "Please select payment option")
            return
        }
        self.confirmAlert(paymentWay:selectedMethod.id)

    }
    private func showAlert(msg:String){
        Constants.displayAlert(viewController: self, message: msg, seconds: 1.75)
    }
   
    private func confirmAlert(paymentWay:PaymentMethod) {
        orderID = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.getDraftOrder.rawValue)
       guard let id = orderID else {
           self.showAlert(msg: "Failed to containue to pay")
           return
       }
        Constants.showAlertWithAction(on: self, title: "Confirmation", message: "Are you sure you want to choose to pay in \(paymentWay)?", isTwoBtn: true, firstBtnTitle: "No", actionBtnTitle: "Yes"){ _ in
            switch paymentWay{
            case PaymentMethod.cash:
                self.CompleteOrder(id: id)
            case PaymentMethod.payPal:
                print("\(paymentWay)")
            case PaymentMethod.applePay:
                print("\(paymentWay)")
                self.startApplePay()
            case PaymentMethod.creditCart:
                print("\(paymentWay)")
            }
        }
    }
    private func CompleteOrder(id:Int){
        if id != 0{
            self.viewModel.completeDraftOrder(orderID: id)
        }else{
            Constants.displayAlert(viewController: self, message: "Error Can't complete your order", seconds: 2.0)
        }
    }
    
    private func observeOnOrder(){
        viewModel.isCompleted.subscribe{ isComplete in
            if isComplete {
            DispatchQueue.main.async {
                UserDefaultsHelper.shared.clearUserData(key: UserDefaultsConstants.getDraftOrder.rawValue)
                print("IsComplete \(UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.getDraftOrder.rawValue))")
                }
                Constants.showAlertWithAction(on: self, title: "Information", message: "Payment Done Successfully!", actionBtnTitle: "OK"){ _ in
                    self.navigateToHome()
                }
            } else {
                print("Failed to complete draft order: Unknown error")
                self.showAlert(msg: "Failed at payment please try again later")
            }
        }.disposed(by: disposeBag)
    }
    private func navigateToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? UITabBarController {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                window.rootViewController = tabBarController
                window.makeKeyAndVisible()
                
                // Optional: Add a transition animation
                let options: UIView.AnimationOptions = .transitionFlipFromRight
                UIView.transition(with: window, duration: 0.5, options: options, animations: {}, completion: nil)
            }
        }
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
    
    func startApplePay() {
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [.visa, .masterCard, .amex]) {
            let paymentRequest = PKPaymentRequest()
            paymentRequest.merchantIdentifier = "your.merchant.identifier"
            paymentRequest.supportedNetworks = [.visa, .masterCard, .amex]
            paymentRequest.merchantCapabilities = .capability3DS
            let currency:String? = UserDefaultsHelper.shared.getCurrencyFromUserDefaults().uppercased()
            paymentRequest.countryCode = draftOrder?.shippingAddress?.countryCode ?? "EGP"
            paymentRequest.currencyCode = self.userCurrency
            
            let totalAmount = calculateTotalAmount()
            let summaryItem = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(decimal: totalAmount))
            paymentRequest.paymentSummaryItems = [summaryItem]
            
            if let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) {
                paymentVC.delegate = self
                present(paymentVC, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Apple Pay is not available on this device or no card is set up.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

extension PaymentViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let paymentToken = payment.token
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
            self.CompleteOrder(id:self.orderID ?? 0)
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func calculateTotalAmount() -> Decimal {
        guard let totalString = draftOrder?.subtotalPrice , let total = Double(totalString)else {
            return Decimal(0.0)
        }
       return Decimal(total)
   }
}

extension PaymentViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTableViewCell", for: indexPath) as! PaymentMethodTableViewCell
        let payment = paymentList[indexPath.row]
        if payment.id == PaymentMethod.applePay {
            cell.paymentMethodImage.image = isDarkMode ? UIImage(named: "applePayLight") : UIImage(named: payment.imageName)
        }else{
            cell.paymentMethodImage.image = UIImage(named: payment.imageName)
        }
        cell.paymentMethodLabel.text = payment.paymentMethod
        return cell
    }
}

extension PaymentViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? PaymentMethodTableViewCell{
            cell.contentView.backgroundColor = UIColor(named: "btnColor") ?? UIColor.black
            
            selectedMethod = paymentList[indexPath.row]
            if selectedMethod?.id == PaymentMethod.applePay{
                //cell.paymentMethodImage.image = UIImage(named: "applePayLight")
                cell.paymentMethodImage.image = isDarkMode ? UIImage(named: selectedMethod!.imageName) : UIImage(named: "applePayLight")
            }
            cell.paymentMethodLabel.textColor = UIColor(named: "theme") ?? UIColor.white
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? PaymentMethodTableViewCell{
            cell.contentView.backgroundColor = UIColor(named: "theme") ?? UIColor.white
            cell.paymentMethodLabel.textColor = UIColor(named: "btnColor") ?? UIColor.black
            selectedMethod = paymentList[indexPath.row]
            if selectedMethod?.id == PaymentMethod.applePay{
                cell.paymentMethodImage.image = isDarkMode ? UIImage(named: "applePayLight") : UIImage(named: selectedMethod!.imageName)
            }

        }
    }
}

