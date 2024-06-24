//
//  ShippingAddressViewController.swift
//  EleganceHub
//
//  Created by AYA on 02/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class ShippingAddressViewController: UIViewController, UpdateLocationDelegate {
    
    @IBOutlet weak var appBar: CustomAppBarUIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let isDarkMode = UserDefaultsHelper.shared.isDarkMode()
    private let itemDeletedSubject = PublishSubject<IndexPath>()
    var isDeleteItem: Bool?
    //private let itemEditedSubject = PublishSubject<IndexPath>()

    
    var isFromCart: Bool = false
    var orderID: Int? = nil
    var customerID: Int?
    
    let viewModel = AddressesViewModel()
    let disposeBag = DisposeBag()
    
    var networkPresenter :NetworkManager?
    var isConnected:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commenInit()
        setupTableViewBinding()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkPresenter = NetworkManager(vc: self)
        
        appBar.setUpBtnsThemes()
        
        if isDarkMode{
            appBar.trailingIcon.setImage(UIImage(named: "add"), for: .normal)
        }else{
            appBar.trailingIcon.setImage(UIImage(named: "add-Light"), for: .normal)
        }
    }
    
    private func commenInit() {
        appBar.secoundTrailingIcon.isHidden = true
        appBar.lableTitle.text = "Shipping Address"
        //appBar.trailingIcon.setImage(UIImage(named: "add"), for: .normal)
        appBar.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        appBar.trailingIcon.addTarget(self, action: #selector(addNewLocation), for: .touchUpInside)
        
        tableView.register(UINib(nibName: "AddressesTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressesTableViewCell")
        tableView.separatorStyle = .none
        tableView.allowsSelection = isFromCart
        
        if isFromCart{
            setupNavigation()
            viewModel.navigateToNextScreen = { selectedAddress in
                //let selectedAddress = viewModel.addresses[indexPath.row]
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let viewController = storyboard.instantiateViewController(withIdentifier: "OrderCheckOutViewController") as? OrderCheckOutViewController {
                    viewController.selectedAddress = selectedAddress
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    private func setupNavigation() {
        tableView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            guard let self = self else {return}
            print("selected index is \(indexPath)")
            //let selectedAddress = self.viewModel.addresses.value[indexPath.row]
            print("selected item \(indexPath.item)")
            self.confirmAlert(selectedAddressIndex: indexPath.row)
        }).disposed(by: disposeBag)
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addNewLocation() {
        guard let isConnected = isConnected else {return}
        if isConnected{
            let locationVC = LocationViewController()
            locationVC.delegate = self
            self.present(locationVC, animated: true)
        }else{
            ConnectivityUtils.showConnectivityAlert(from: self)
        }
    }
    
    private func setupTableViewBinding() {
        viewModel.addresses.asObserver().bind(to: tableView.rx.items(cellIdentifier: "AddressesTableViewCell", cellType: AddressesTableViewCell.self)) { index, address, cell in
          
            cell.setCellData(address: address)
        }.disposed(by: disposeBag)
        
        itemDeletedSubject
            .withLatestFrom(viewModel.addresses) { (indexPath, addresses) in
                return (indexPath, addresses)
            }.subscribe(onNext: { [weak self] (indexPath, addresses) in
                guard let self = self , let isDeleteItem = self.isDeleteItem else { return }
                let address = addresses[indexPath.row]
                guard let id = self.customerID, let addresID = address.id  else {
                    print("id = \(self.customerID), let addresID = \(address.id) , let isDeleteItem = \(self.isDeleteItem) ")
                    return
                }
                if let isDefault = address.addressDefault{
                    if isDeleteItem{
                        if isDefault && isDeleteItem {
                            Constants.displayAlert(viewController: self, message: "You can't delete your default address.", seconds: 1.75)
                        }else{
                            self.viewModel.removeAddress(customerID: id, addressID: addresID)
                        }
                    }else{
                        if isDefault && !isDeleteItem {
                            Constants.displayAlert(viewController: self, message: "This address is already set as the default address.", seconds: 1.75)
                        }else{
                            self.viewModel.setAddressAsDefault(customerID: id, addressID: addresID)
                        }
                    }
                }
            }).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func loadingObserverSetUp() {
        viewModel.isLoading.subscribe { isloading in
            self.showActivityIndicator(isloading)
        }.disposed(by: disposeBag)
        handleEmptyState()

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
    
    func didAddNewAddress() {
        guard let id = self.customerID else { return }
        viewModel.getAllAddresses(customerID: id)
    }
    
    private func confirmAlert(selectedAddressIndex: Int) {
        Constants.showAlertWithAction(on: self, title: "Confirm Shipping", message: "Are you sure you want to ship to this address?", isTwoBtn: true, firstBtnTitle: "NO", actionBtnTitle: "Yes"){ _ in
            guard let id = self.orderID else { return }
            if id != 0 {
                self.viewModel.addAddressToOrder(orderID: id, addressIndex: selectedAddressIndex)
            }
        }
        
    }
    private func handleCartEmptyState(isEmpty: Bool,imageName:String) {
        if isEmpty {
            print("Cart is empty")
            //let emptyLabel = UILabel(frame: self.cartTableView.bounds)
            if let emptyImage = UIImage(named: imageName) {
               let imageView = UIImageView(image: emptyImage)
                imageView.contentMode = .center
               imageView.frame = self.tableView.bounds
               self.tableView.backgroundView = imageView
           }
        } else {
            self.tableView.backgroundView = nil
        }
    }
    
    private func handleEmptyState() {
        viewModel.addresses
            .map { $0.isEmpty }
            .subscribe(onNext: { [weak self] isEmpty in
              self?.handleCartEmptyState(isEmpty: isEmpty,imageName: "emptybox")
            })
            .disposed(by: disposeBag)
    }
}
   

extension ShippingAddressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { action, view, completionHandler in
            self.showDeleteConfirmationAlert { confirmed in
                if confirmed {
                    print("delete addressssss self.isDeleteItem \(self.isDeleteItem)")
                    self.deleteItem(at: indexPath)
                }
                completionHandler(confirmed)
            }
        }
        
        deleteAction.backgroundColor = UIColor(named: "btnColor") ?? .black
        
        let trashIcon = UIImage(systemName: "trash")?.withTintColor(UIColor(named: "theme") ?? .black, renderingMode: .alwaysOriginal)
        deleteAction.image = trashIcon
        let editingAction = UIContextualAction(style: .normal, title: ""){action, view, completionHandler in
            
            //guard let self = self else {return}
            self.showEdditingConfirmationAlert { confirmed in
                if confirmed {
                    print("eddetied addressssss self.isDeleteItem \(self.isDeleteItem)")
                    self.deleteItem(at: indexPath)
                }
                print("Edit addressss confirmed \(confirmed)")
                completionHandler(confirmed)
            }
        }
        let editIcon = UIImage(systemName: "square.and.pencil")?.withTintColor(UIColor(named: "theme") ?? .black, renderingMode: .alwaysOriginal)
        editingAction.image = editIcon
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction,editingAction])
        //configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
    
    func showDeleteConfirmationAlert(completion: @escaping (Bool) -> Void) {
        Constants.showAlertWithAction(on: self, title: "Confirm Delete", message: "Are you sure you want to delete this address?", isTwoBtn: true, firstBtnTitle: "Cancel", actionBtnTitle: "Delete", style: .destructive) { confirmed in
            self.isDeleteItem = true
            completion(true)
        }
    }
    func showEdditingConfirmationAlert(completion: @escaping (Bool) -> Void) {
        Constants.showAlertWithAction(on: self, title: "Set Default Address", message: "Are you sure you want to set this address as default?", isTwoBtn: true, firstBtnTitle: "No", actionBtnTitle: "Yes", style: .default) { confirmed in
            self.isDeleteItem = false
            completion(true)
        }
    }
    private func deleteItem(at indexPath: IndexPath) {
        itemDeletedSubject.onNext(indexPath)
    }
}

extension ShippingAddressViewController: ConnectivityProtocol, NetworkStatusProtocol{
    
    func networkStatusDidChange(connected: Bool) {
        isConnected = connected
        print("networkStatusDidChange called \(isConnected)")
        checkForConnection()
    }
    
    private func checkForConnection(){
        guard let isConnected = isConnected else {
            ConnectivityUtils.showConnectivityAlert(from: self)
            print("is connect nilllllll")
            return
        }
        if isConnected{
            getData()
        }else{
            //ConnectivityUtils.showConnectivityAlert(from: self)
            isShowViews()
        }
    }
    
    private func getData(){
        customerID = UserDefaultsHelper.shared.getLoggedInUserID()
        guard let id = customerID else { return }
        viewModel.getAllAddresses(customerID: id)
        loadingObserverSetUp()
        orderID = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.getDraftOrder.rawValue)
    }
    private func isShowViews(){
        guard let isConnected = isConnected else {return}
        activityIndicator.isHidden = true
        viewModel.addresses.onNext([])
        let  isDarkMode = UserDefaultsHelper.shared.isDarkMode()
        if (isDarkMode && !isConnected){
            handleCartEmptyState(isEmpty: true, imageName: "no-wifi-light")
        }else if (!isDarkMode && !isConnected){
            handleCartEmptyState(isEmpty: true, imageName: "no-wifi")
        }
    }
}

