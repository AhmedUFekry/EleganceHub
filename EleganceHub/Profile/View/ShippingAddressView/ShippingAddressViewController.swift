//
//  ShippingAddressViewController.swift
//  EleganceHub
//
//  Created by AYA on 02/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class ShippingAddressViewController: UIViewController,UpdateLocationDelegate {
    
    @IBOutlet weak var appBar:CustomAppBarUIView!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isFromCart:Bool = false
    var orderID:Int? = nil
    
    //var customerData:User? = User(id: 8222308237587, first_name: "shimaa", last_name: "shimo", email: "", password: "")
    var customerID:Int?
    
    let viewModel = AddressesViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        commenInit()
        setupTableViewBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        customerID = UserDefaultsHelper.shared.getLoggedInUserID()
        guard let id = customerID else {return}
        viewModel.getAllAddresses(customerID: id)
        
        loadingObserverSetUp()
        
        orderID = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.getDraftOrder.rawValue)
    }
    
    private func commenInit(){
        appBar.secoundTrailingIcon.isHidden = true
        appBar.lableTitle.text = "Shipping Address"
        appBar.trailingIcon.setImage(UIImage(named: "add"), for: .normal)
        appBar.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        appBar.trailingIcon.addTarget(self, action: #selector(addNewLocation), for: .touchUpInside)

        tableView.register(UINib(nibName: "AddressesTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressesTableViewCell")
        
        tableView.separatorStyle = .none
        if isFromCart{
            tableView.allowsSelection = true
            viewModel.navigateToNextScreen = {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController =  storyboard.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController
                self.navigationController?.pushViewController(viewController!, animated: true)
            }
        }else{
            tableView.allowsSelection = false
        }
        //tableView.rx.setDelegate(self)
               // .disposed(by: disposeBag)
    }
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addNewLocation(){
        let locationVC = LocationViewController()
        locationVC.delegate = self
        self.present(locationVC, animated: true)
    }

    private func setupTableViewBinding() {
        viewModel.addresses.asObserver().bind(to: tableView.rx.items(cellIdentifier: "AddressesTableViewCell", cellType: AddressesTableViewCell.self)) { index, address, cell in
            cell.setCellData(address:address)
            
        }.disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
        .withLatestFrom(viewModel.addresses) { (indexPath, addresses) in
            return (indexPath, addresses)
        }
        .subscribe(onNext: { [weak self] (indexPath, addresses) in
            guard let self = self else { return }
            let address = addresses[indexPath.row]
            guard let id = self.customerID else {return}
            self.viewModel.removeAddress(customerID: id , addressID: address.id!)
        })
        .disposed(by: disposeBag)

        tableView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            guard let self = self else {return}
            print("selected index is \(indexPath)")
            //let selectedAddress = self.viewModel.addresses.value[indexPath.row]
            print("selected item \(indexPath.item)")
            self.confirmAlert(selectedAddressIndex: indexPath.row)
        }).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
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
    
    func didAddNewAddress() {
        guard let id = self.customerID else {return}
        viewModel.getAllAddresses(customerID: id)
    }
    
    private func confirmAlert(selectedAddressIndex:Int){
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to shipping to this address?", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Yes", style: .default) { _ in
            print("Ok btn Tapped")
            guard let id = self.orderID else {return}
            if id != 0{
                self.viewModel.addAddressToOrder(orderID: id, addressIndex:selectedAddressIndex)
            }
        }
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okBtn)
        alert.addAction(cancelBtn)
        self.present(alert, animated: true)
    }
}

extension ShippingAddressViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            220
        }
    
}
