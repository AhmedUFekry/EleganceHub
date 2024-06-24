import UIKit
import RxSwift
import RxCocoa
import RxRelay

class CartViewController: UIViewController {

    @IBOutlet weak var totalItemPrice: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var checkOutBtn: UIButton!
    
    
    private let itemDeletedSubject = PublishSubject<IndexPath>()
    
    var viewModel: CartViewModelProtocol = CartViewModel()
    var currencyViewModel = CurrencyViewModel()
    var disposeBag = DisposeBag()
    var customerID: Int?
    var draftOrderID: Int!
    var rate: Double?
    var userCurrency:String?
    
    var draftOrder:DraftOrder?
    
    var networkPresenter :NetworkManager?
    var isConnected:Bool?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networkPresenter = NetworkManager(vc: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpBtnsThemes()
        
        let cartNibCell = UINib(nibName: "CartTableViewCell", bundle: nil)
        cartTableView.register(cartNibCell, forCellReuseIdentifier: "CartTableViewCell")
       
        cartTableView.separatorStyle = .none
        cartTableView.allowsSelection = false
        
        viewModel.showAlert = {[weak self] in
            guard let self = self else {return}
            let isIncrement = self.viewModel.showAlertQuantity
            guard let isIncrement = isIncrement else {return}
            if isIncrement {
                self.showAlertError(err: "Sorry, this product is currently out of stock.")
            }
        }
    }
    
    private func setUpBtnsThemes(){
        let isDarkMode = UserDefaultsHelper.shared.isDarkMode()
        if isDarkMode{
            backBtn.setImage(UIImage(named: "backLight"), for: .normal)
            checkOutBtn.setImage(UIImage(named: "forward-button-Light"), for: .normal)
        }else{
            backBtn.setImage(UIImage(named: "back"), for: .normal)
            checkOutBtn.setImage(UIImage(named: "forward-button"), for: .normal)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkoutBtn(_ sender: UIButton) {
        if customerID != nil {
            if draftOrderID != 0 {
                let locationVC = ShippingAddressViewController()
                locationVC.isFromCart = true
                self.navigationController?.pushViewController(locationVC, animated: true)
            } else {
                self.showAlertError(err: "Your cart is empty. Please add items to continue shopping.")
            }
        } else {
            self.showAlertError(err: "Please log in first to continue.")
        }
    }
    
  
    private func setupTableViewBinding() {
        viewModel.lineItemsList
            .bind(to: cartTableView.rx.items(cellIdentifier: "CartTableViewCell", cellType: CartTableViewCell.self)) { [weak self] index, item, cell in
                guard let self = self else { return }
                cell.setCellData(order: item)
                
                let convertedPrice = convertPrice(price: item.price ?? "0", rate: self.rate ?? 1.0)
                cell.productPriceLabel.text = "\(String(format: "%.2f", convertedPrice)) \(self.userCurrency ?? "USD")"
                
                cell.decreaseQuantityBtn.tag = index
                cell.IncreaseQuantityBtn.tag = index
                cell.IncreaseQuantityBtn.addTarget(self, action: #selector(self.increaceQuantityTapped(_:)), for: .touchUpInside)
                cell.decreaseQuantityBtn.addTarget(self, action: #selector(self.decreaseQuantityTapped(_:)), for: .touchUpInside)
            }
            .disposed(by: disposeBag)
        
        itemDeletedSubject
            .withLatestFrom(viewModel.lineItemsList) { (indexPath, orders) in
                return (indexPath, orders)
            }.subscribe(onNext: { [weak self] (indexPath, orders) in
                guard let self = self else { return }
                let order = orders[indexPath.row]
                if orders.count <= 1 {
                    print("Last Item")
                    self.viewModel.deleteDraftOrder(orderID: self.draftOrderID)
                } else {
                    print("Not last item")
                    if let orderID = order.id {
                        print("orderID = order.id \(orderID)")
                        self.viewModel.deleteItemFromDraftOrder(orderID: self.draftOrderID, itemID: orderID)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        cartTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func bindDataToView() {
        
        viewModel.lineItemsList
            .map { "Total(\($0.count) item):" }
            .bind(to: totalItemPrice.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.lineItemsList
            .compactMap({ [weak self] items -> Double in
                guard let self = self else { return 0.0 }
                return items.reduce(0.0) { partialResult, item in
                    guard let priceString = item.price, var price = Double(priceString) else {
                        return 0.0
                    }
                    price = price * Double(item.quantity ?? 1)
                    let convertedPrice = convertPrice(price: String(price), rate: self.rate ?? 1.0)
                    print("partialResult + convertedPrice \(partialResult + convertedPrice)")
                    return partialResult + convertedPrice
                }
            })
            .subscribe(onNext: { [weak self] totalPrice in
                guard let self = self else { return }
                let total = String(format: "%.2f", totalPrice)
                print("Total price is \(total)")
                self.totalPriceLabel.text = "\(total) \(self.userCurrency ?? "USD")"
            })
            .disposed(by: disposeBag)
    }
    
    private func loadingObserverSetUp() {
        viewModel.isLoading.subscribe { isLoading in
            self.showActivityIndicator(isLoading)
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
    
    private func onErrorObserverSetUp() {
        viewModel.error.subscribe { err in
            self.showAlertError(err: err.error?.localizedDescription ?? "Error")
        }.disposed(by: disposeBag)
    }
    
    private func showAlertError(err: String) {
        Constants.displayAlert(viewController: self, message: err, seconds: 1.8)
    }
    
    private func handleCartEmptyState(isEmpty: Bool,imageName:String) {
        if isEmpty {
            print("Cart is empty")
            if let emptyImage = UIImage(named: imageName) {
               let imageView = UIImageView(image: emptyImage)
                imageView.contentMode = .center
               imageView.frame = self.cartTableView.bounds
               self.cartTableView.backgroundView = imageView
           }
            UserDefaultsHelper.shared.clearUserData(key: UserDefaultsConstants.getDraftOrder.rawValue)
            draftOrderID = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.getDraftOrder.rawValue)
            print("draft order is removed \(UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.getDraftOrder.rawValue)) draft order \(draftOrderID )")
        }
    }
    
    private func handleEmptyState() {
        viewModel.lineItemsList
            .map { $0.isEmpty }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isEmpty in
                if isEmpty {
                    self?.handleCartEmptyState(isEmpty: isEmpty,imageName: "emptycart")
                } else {
                    self?.cartTableView.backgroundView = nil
                }
            })
            .disposed(by: disposeBag)
    }
  
    @objc func increaceQuantityTapped(_ sender: UIButton) {
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
        self.viewModel.updateLatestListItem(orderID: draftOrderID)
    }
}

extension CartViewController:UITableViewDelegate{

    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { action, view, completionHandler in
            self.showDeleteConfirmationAlert { confirmed in
                if confirmed {
                    self.deleteItem(at: indexPath)
                }
                completionHandler(confirmed)
            }
        }
        
        deleteAction.backgroundColor = UIColor(named: "btnColor") ?? .black
        
        let trashIcon = UIImage(systemName: "trash")?.withTintColor(UIColor(named: "theme") ?? .black, renderingMode: .alwaysOriginal)
        deleteAction.image = trashIcon
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
    
    func showDeleteConfirmationAlert(completion: @escaping (Bool) -> Void) {
        Constants.showAlertWithAction(on: self, title: "Confirm Delete", message: "Are you sure you want to delete this item?", isTwoBtn: true, firstBtnTitle: "Cancel", actionBtnTitle: "Delete", style: .destructive) { confirmed in
            completion(true)
        }
    }
    private func deleteItem(at indexPath: IndexPath) {
        itemDeletedSubject.onNext(indexPath)
    }
}


extension CartViewController: ConnectivityProtocol, NetworkStatusProtocol{
    
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
            ConnectivityUtils.showConnectivityAlert(from: self)
            isShowViews()
        }
    }
    
    private func getData(){
        customerID = UserDefaultsHelper.shared.getLoggedInUserID()
        guard customerID != nil else { return }
        
        //viewModel.getDraftOrderForUser(orderID: 1157765955859)
        draftOrderID = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.getDraftOrder.rawValue)
        if draftOrderID != 0 {
            //if let userDraftOrder = draftOrder,let linItemList = userDraftOrder.lineItems {
                //viewModel.lineItemsList.onNext(linItemList)
              //  print("Data Passed \(linItemList)")
            //}else{
                viewModel.getDraftOrderForUser(orderID: draftOrderID)
           // }
        } else {
            handleCartEmptyState(isEmpty: true,imageName: "emptycart")
        }
        rate = UserDefaultsHelper.shared.getDataDoubleFound(key: UserDefaultsConstants.currencyRate.rawValue)
        userCurrency = UserDefaultsHelper.shared.getCurrencyFromUserDefaults().uppercased()
        
        setupTableViewBinding()
        loadingObserverSetUp()
        bindDataToView()
        handleEmptyState()
        
    }
    private func isShowViews(){
        guard let isConnected = isConnected else {return}
        activityIndicator.isHidden = !isConnected
        let  isDarkMode = UserDefaultsHelper.shared.isDarkMode()
        if (isDarkMode && !isConnected){
            handleCartEmptyState(isEmpty: true, imageName: "no-wifi-light")
        }else if (!isDarkMode && !isConnected){
            handleCartEmptyState(isEmpty: true, imageName: "no-wifi")
        }
    }
}

