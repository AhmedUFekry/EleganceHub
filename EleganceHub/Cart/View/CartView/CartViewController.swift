//
//  CartViewController.swift
//  EleganceHub
//
//  Created by AYA on 25/05/2024.
//

import UIKit
import RxSwift
import RxCocoa

class CartViewController: UIViewController {

    @IBOutlet weak var totalItemPrice: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var countOfItemInCart: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel:CartViewModelProtocol = CartViewModel()
    var disposeBag = DisposeBag()
    var customerID = 8229959500051
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllDraftOrdersForUser(customerID: customerID)
        setupTableViewBinding()
        loadingObserverSetUp()
        bindDataToView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cartNibCell = UINib(nibName: "CartTableViewCell", bundle: nil)
        cartTableView.register(cartNibCell, forCellReuseIdentifier: "CartTableViewCell")
            
        countOfItemInCart.backgroundColor  = UIColor.red
        countOfItemInCart.layer.cornerRadius = 8
        countOfItemInCart.layer.masksToBounds = true
        cartTableView.separatorStyle = .none
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkoutBtn(_ sender: UIButton) {
        let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    private func setupTableViewBinding() {
        
        viewModel.draftOrdersList.asObserver().bind(to: cartTableView.rx.items(cellIdentifier: "CartTableViewCell", cellType: CartTableViewCell.self)) { index, order, cell in
            guard let productItem = order.lineItems?.first else {
                return
            }
            cell.setCellData(order:productItem)
            
        }.disposed(by: disposeBag)
           
        cartTableView.rx.itemDeleted
        .withLatestFrom(viewModel.draftOrdersList) { (indexPath, orders) in
            return (indexPath, orders)
        }.subscribe(onNext: { [weak self] (indexPath, orders) in
            guard let self = self else { return }
            let order = orders[indexPath.row]
            if let orderID = order.id {
                self.viewModel.deleteDraftOrder(orderID: orderID, customerID: self.customerID)
            }
            
        })
        .disposed(by: disposeBag)

        //tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    private func bindDataToView(){
        viewModel.draftOrdersList
            .map { String($0.count) }
            .bind(to: countOfItemInCart.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.draftOrdersList
            .map { "Total(\($0.count) item):" }
            .bind(to: totalItemPrice.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.draftOrdersList
            .map { orders in //map operator to transform each DraftOrder into an array of prices
                orders.compactMap { order in //to remove any nil values.
                    guard let priceString = order.lineItems?.first?.price, let price = Double(priceString) else {
                        return nil
                    }
                    return price
                }
            }
            .map { prices in
                prices.reduce(0.0, +)
            }
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
        Constants.displayAlert(viewController: self,message: err, seconds: 3)
    }


}

//extension CartViewController: UITableViewDelegate{
////    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        ret
////    }
//}

extension CartViewController{
   
}
