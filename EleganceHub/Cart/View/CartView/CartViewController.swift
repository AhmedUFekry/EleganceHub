//
//  CartViewController.swift
//  EleganceHub
//
//  Created by AYA on 25/05/2024.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class CartViewController: UIViewController {

    @IBOutlet weak var totalItemPrice: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var countOfItemInCart: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel:CartViewModelProtocol = CartViewModel()
    var currencyViewModel = CurrencyViewModel()
    var disposeBag = DisposeBag()
    var customerID:Int?
    var draftOrder:Int!
    var rate : Double!
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userCurrency = UserDefaultsHelper.shared.getCurrencyFromUserDefaults().uppercased()
        
        customerID = UserDefaultsHelper.shared.getLoggedInUserID()
        guard customerID != nil else{return}
        
        draftOrder = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.getDraftOrder.rawValue)
        if(draftOrder != 0){
            viewModel.getDraftOrderForUser(orderID: draftOrder)
        }else{
            handleCartEmptyState(isEmpty: true)
        }
        
        setupTableViewBinding()
        loadingObserverSetUp()
        bindDataToView()
        handleEmptyState()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyViewModel.rateClosure = {
            [weak self] rate in
            DispatchQueue.main.async {
                self?.rate = rate
            }
        }
        currencyViewModel.getRate()
        let cartNibCell = UINib(nibName: "CartTableViewCell", bundle: nil)
        cartTableView.register(cartNibCell, forCellReuseIdentifier: "CartTableViewCell")
       
        countOfItemInCart.backgroundColor  = UIColor.red
        countOfItemInCart.layer.cornerRadius = 8
        countOfItemInCart.layer.masksToBounds = true
        cartTableView.separatorStyle = .none
        cartTableView.allowsSelection = false
        
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkoutBtn(_ sender: UIButton) {
        if customerID != nil {
            if draftOrder != 0{
                let locationVC = ShippingAddressViewController()
                //locationVC.delegate = self
                //self.present(locationVC, animated: true)
                locationVC.isFromCart = true
                self.navigationController?.pushViewController(locationVC, animated: true)
//                let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController
//                self.navigationController?.pushViewController(viewController!, animated: true)
            }else{
                self.showAlertError(err: "Your cart is Empty add new items to it to continue buying")
            }
        }else{
            self.showAlertError(err: "Please Log in First")
        }
    }
    
    private func setupTableViewBinding() {
        
//        viewModel.lineItemsList
//        /*.asObserver()*/
//            .bind(to: cartTableView.rx.items(cellIdentifier: "CartTableViewCell", cellType: CartTableViewCell.self)){[weak self] index, item, cell in
//                guard let self = self else { return }
//            cell.decreaseQuantityBtn.tag = index
//            cell.IncreaseQuantityBtn.tag = index
//            cell.setCellData(order: item)
//            cell.IncreaseQuantityBtn.addTarget(self, action: #selector(self.increaceQuantityTapped(_:)), for: .touchUpInside)
//            cell.decreaseQuantityTapped.addTarget(self, action: #selector(self.decreaceQuantityTapped(_:)), for: .touchUpInside)
//        }.disposed(by: disposeBag)
        viewModel.lineItemsList
            .bind(to: cartTableView.rx.items(cellIdentifier: "CartTableViewCell", cellType: CartTableViewCell.self)){[weak self] index, item, cell in
                guard let self = self else { return }
                
                cell.setCellData(order: item)
                cell.decreaseQuantityBtn.tag = index
                cell.IncreaseQuantityBtn.tag = index
                cell.IncreaseQuantityBtn.addTarget(self, action: #selector(self.increaceQuantityTapped(_:)), for: .touchUpInside)
                cell.decreaseQuantityBtn.addTarget(self, action: #selector(self.decreaseQuantityTapped(_:)), for: .touchUpInside)
                
            }.disposed(by: disposeBag)
        
        
        //cartTableView.rx.itemAccessoryButtonTapped
        
        cartTableView.rx.itemDeleted
        .withLatestFrom(viewModel.lineItemsList) { (indexPath, orders) in
            return (indexPath, orders)
        }.subscribe(onNext: { [weak self] (indexPath, orders) in
            guard let self = self else { return }
            let order = orders[indexPath.row]
            if(orders.count <= 1){
                print("Last Item")
                self.viewModel.deleteDraftOrder(orderID: self.draftOrder)
               // self.handleCartEmptyState(isEmpty: true)
            }else{
                print("not last Item Item")
                if let orderID = order.id{
                    print("orderID = order.id \(orderID)")
                    self.viewModel.deleteItemFromDraftOrder(orderID: self.draftOrder, itemID: orderID)
                }
            }
        })
        .disposed(by: disposeBag)

    }
    
    private func bindDataToView(){
        viewModel.lineItemsList
            .map { String($0.count) }
            .bind(to: countOfItemInCart.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.lineItemsList
            .map { "Total(\($0.count) item):" }
            .bind(to: totalItemPrice.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.lineItemsList
            .compactMap({ items in
                items.reduce(0.0) { partialResult, item in
                    guard let priceString = item.price, var price = Double(priceString) else {
                        return 0.0
                    }
                    price = price * Double(item.quantity ?? 1)
                    print("partialResult + price \(partialResult + price)")
                   return partialResult + price
                }
            })
            .subscribe(onNext: { totalPrice in
                
                var total = String(format: "%.2f", totalPrice)
                print("Total price is \(total)")
                self.totalPriceLabel.text = "$\(total)"
            })
            .disposed(by: disposeBag)
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
            self.showAlertError(err: err.error?.localizedDescription ?? "Error")
        }.disposed(by: disposeBag)
    }
    private func showAlertError(err:String){
        Constants.displayAlert(viewController: self,message: err, seconds: 2)
    }
    
   
    private func handleCartEmptyState(isEmpty: Bool) {
        if isEmpty {
            print("Cart is empty")
            let emptyLabel = UILabel(frame: self.cartTableView.bounds)
            emptyLabel.text = "Your cart is empty."
            emptyLabel.textAlignment = .center
            self.cartTableView.backgroundView = emptyLabel
            UserDefaultsHelper.shared.clearUserData(key: UserDefaultsConstants.getDraftOrder.rawValue)
            draftOrder = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.getDraftOrder.rawValue)
            print("draft order is removed \(UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.getDraftOrder.rawValue)) draft order \(draftOrder )")
        }
    }
    private func handleEmptyState() {
        viewModel.lineItemsList
            .map { $0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isEmpty in
                if isEmpty {
                    self?.handleCartEmptyState(isEmpty: isEmpty)
                } else {
                    self?.cartTableView.backgroundView = nil
                }
            })
            .disposed(by: disposeBag)
    }
  
    @objc func increaceQuantityTapped(_ sender: UIButton){
        print("Increased")
        let index = sender.tag
         print("Index \(index)")
        viewModel.incrementQuantity(at: index)
        
    }
    
    @objc func decreaseQuantityTapped(_ sender: UIButton) {
           let index = sender.tag
        print("Index \(index)")
       viewModel.decremantQuantity(at: index)
   }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        cartTableView.dataSource = nil
        cartTableView.delegate = nil
        print("viewWillDisappear")
        self.viewModel.updateLatestListItem(orderID: draftOrder)
    }
}
