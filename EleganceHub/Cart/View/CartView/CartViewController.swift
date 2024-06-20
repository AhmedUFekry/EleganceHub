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
    
    private let itemDeletedSubject = PublishSubject<IndexPath>()
    
    var viewModel: CartViewModelProtocol = CartViewModel()
    var currencyViewModel = CurrencyViewModel()
    var disposeBag = DisposeBag()
    var customerID: Int?
    var draftOrder: Int!
    var rate: Double!
    let userCurrency = UserDefaultsHelper.shared.getCurrencyFromUserDefaults().uppercased()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        customerID = UserDefaultsHelper.shared.getLoggedInUserID()
        guard customerID != nil else { return }
        
        //viewModel.getDraftOrderForUser(orderID: 1157765955859)
        draftOrder = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.getDraftOrder.rawValue)
        if draftOrder != 0 {
            viewModel.getDraftOrderForUser(orderID: draftOrder)
        } else {
            handleCartEmptyState(isEmpty: true)
        }
        
        setupTableViewBinding()
        loadingObserverSetUp()
        bindDataToView()
        handleEmptyState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyViewModel.rateClosure = { [weak self] rate in
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
            if draftOrder != 0 {
                let locationVC = ShippingAddressViewController()
                locationVC.isFromCart = true
                self.navigationController?.pushViewController(locationVC, animated: true)
            } else {
                self.showAlertError(err: "Your cart is Empty add new items to it to continue buying")
            }
        } else {
            self.showAlertError(err: "Please Log in First")
        }
    }
    
  
    
    private func setupTableViewBinding() {
        viewModel.lineItemsList
            .bind(to: cartTableView.rx.items(cellIdentifier: "CartTableViewCell", cellType: CartTableViewCell.self)) { [weak self] index, item, cell in
                guard let self = self else { return }
                cell.setCellData(order: item)
                
                let convertedPrice = convertPrice(price: item.price ?? "0", rate: self.rate)
                cell.productPriceLabel.text = "\(String(format: "%.2f", convertedPrice)) \(self.userCurrency)"
                
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
                    self.viewModel.deleteDraftOrder(orderID: self.draftOrder)
                } else {
                    print("Not last item")
                    if let orderID = order.id {
                        print("orderID = order.id \(orderID)")
                        self.viewModel.deleteItemFromDraftOrder(orderID: self.draftOrder, itemID: orderID)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        cartTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func bindDataToView() {
        viewModel.lineItemsList
            .map { String($0.count) }
            .bind(to: countOfItemInCart.rx.text)
            .disposed(by: disposeBag)
        
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
                    let convertedPrice = convertPrice(price: String(price), rate: self.rate)
                    print("partialResult + convertedPrice \(partialResult + convertedPrice)")
                    return partialResult + convertedPrice
                }
            })
            .subscribe(onNext: { [weak self] totalPrice in
                guard let self = self else { return }
                let total = String(format: "%.2f", totalPrice)
                print("Total price is \(total)")
                self.totalPriceLabel.text = "\(total) \(self.userCurrency)"
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
        Constants.displayAlert(viewController: self, message: err, seconds: 2)
    }
    
    private func handleCartEmptyState(isEmpty: Bool) {
        if isEmpty {
            print("Cart is empty")
            if let emptyImage = UIImage(named: "emptycart") {
               let imageView = UIImageView(image: emptyImage)
                imageView.contentMode = .center
               imageView.frame = self.cartTableView.bounds
               self.cartTableView.backgroundView = imageView
           }
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
        self.viewModel.updateLatestListItem(orderID: draftOrder)
    }
}

extension CartViewController:UITableViewDelegate{

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
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
        
        deleteAction.backgroundColor = .black
        deleteAction.image = UIImage(systemName: "trash")
        
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
