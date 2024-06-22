//
//  FavoriteViewController.swift
//  EleganceHub
//
//  Created by Shimaa on 09/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var appBarView: CustomAppBarUIView!

    var favoriteProducts: BehaviorRelay<[[String: Any]]> = BehaviorRelay(value: [])
    let disposeBag = DisposeBag()
    var viewModel: ProductDetailViewModel!
    var customerID:Int?
    var product: Product?

    var currencyViewModel = CurrencyViewModel()
    var rate : Double?
    
    let userCurrency = UserDefaultsHelper.shared.getCurrencyFromUserDefaults().uppercased()

   
    private var emptyStateImageView: UIImageView!
    private var emptyStateLabel: UILabel!
    private var emptyStateSubLabel: UILabel!
    
    static let favoriteUpdated = PublishSubject<Void>()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyViewModel.rateClosure = {
            [weak self] rate in
            DispatchQueue.main.async {
                self?.rate = rate
            }
        }
        currencyViewModel.getRate()
        
        viewModel = ProductDetailViewModel(networkManager: ProductDetailNetworkService())
        setupTableView()
        loadFavoriteProducts()
        bindTableView()
        setupTableViewInteractions()
        
        setupEmptyStateUI()
        updateEmptyStateVisibility()
        
        addToCartObserversFuncs()
        
        viewModel.bindingProduct = { [weak self] in
            self?.product = self?.viewModel.observableProduct
        }

        FavoriteViewController.favoriteUpdated
            .subscribe(onNext: { [weak self] in
                self?.loadFavoriteProducts()
                self?.favoriteTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
    }
            
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteTableView.reloadData()
        let  isDarkMode = UserDefaultsHelper.shared.isDarkMode()
        if isDarkMode{
            appBarView.backBtn.setImage(UIImage(named: "backLight"), for: .normal)
        }else{
            appBarView.backBtn.setImage(UIImage(named: "back"), for: .normal)
        }
        
    }
    
    private func setupTableView() {
        favoriteTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        favoriteTableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.appBarView.backBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        self.appBarView.lableTitle.text = "My WishLists"
        self.appBarView.trailingIcon.isHidden = true
        self.appBarView.secoundTrailingIcon.isHidden = true
    }
    
    @objc func backBtnTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    private func loadFavoriteProducts() {
        if let userId = getLoggedInUserID() {
            let fetchedProducts = FavoriteCoreData.shared.fetchFavoritesByUserId(userId: userId) ?? []
            favoriteProducts.accept(fetchedProducts)
            print("Fetched Products: \(fetchedProducts)")
        } else {
            print("User ID not found.")
        }
    }
    

    private func bindTableView() {
        favoriteProducts.bind(to: favoriteTableView.rx.items(cellIdentifier: "CartTableViewCell", cellType: CartTableViewCell.self)) { [weak self] row, product, cell in
            self?.configureCell(cell, with: product, at: row)
        }.disposed(by: disposeBag)
    }

    private func setupTableViewInteractions() {
        favoriteTableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let product = self?.favoriteProducts.value[indexPath.row],
                  let productId = product["id"] as? Int,
                  let customerId = self?.getLoggedInUserID() else {
                return
            }
            self?.showDeleteConfirmationAlert(productId: productId, customerId: customerId, indexPath: indexPath)
        }).disposed(by: disposeBag)
        
        favoriteTableView.rx.modelSelected([String: Any].self).subscribe(onNext: { [weak self] product in
            self?.navigateToProductDetail(product: product)
        }).disposed(by: disposeBag)
    }

    private func configureCell(_ cell: CartTableViewCell, with product: [String: Any], at row: Int) {
        if let title = product["title"] as? String,
           let price = product["price"] as? String,
           let imageUrlString = product["image"] as? String,
           let productType = product["product_type"] as? String,
           let imageUrl = URL(string: imageUrlString) {
            cell.productNameLabel.text = title
            cell.productVarintLabel.text = productType
            var convertedPrice = convertPrice(price: price, rate: self.rate ?? 3.3)
            cell.productPriceLabel.text = "\(String(format: "%.2f", convertedPrice)) \(userCurrency)"
            
            cell.productImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "AppIcon"))
        }
        
        cell.decreaseQuantityBtn.isHidden = true
        cell.IncreaseQuantityBtn.isHidden = true
        cell.productQuantityLabel.isHidden = true
        
        let addToCartBtn = UIButton(type: .system)
        addToCartBtn.setImage(UIImage(systemName: "cart.fill"), for: .normal)
        addToCartBtn.setTitle("Add To Cart", for: .normal)
        addToCartBtn.backgroundColor = UIColor(named: "btnColor") ?? .black
        //addToCartBtn.setTitleColor(.white, for: .normal)
        addToCartBtn.layer.cornerRadius = 10
        
        cell.contentView.addSubview(addToCartBtn)
        
        addToCartBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addToCartBtn.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 220),
            addToCartBtn.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            addToCartBtn.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -18),
            addToCartBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        addToCartBtn.tag = row
        addToCartBtn.addTarget(self, action: #selector(addToCartButtonTapped(_:)), for: .touchUpInside)
    }
    
    func getLoggedInUserID() -> Int? {
        return UserDefaultsHelper.shared.getLoggedInUserID()
    }
    
    @objc func addToCartButtonTapped(_ sender: UIButton) {
        let productIndex = sender.tag
        var product = favoriteProducts.value[productIndex]
        var productData:Product?
        
        if let title = product["title"] as? String,
           let price = product["price"] as? String,
           let imageUrlString = product["image"] as? String,
           let productType = product["product_type"] as? String,
           let imageUrl = URL(string: imageUrlString),
           let productID = product["id"] as? Int
           ,let inventoryID = product["variant_id"] as? Int,
        let quantity = product["inventory_quantity"] as? Int{
            productData = Product(id: productID, title: title, bodyHTML: nil, vendor: nil, productType: productType, handle: nil, status: nil, publishedScope: nil, tags: nil, variants: [Variant(id: inventoryID, productID: productID, title: nil, price: price, sku: nil, position: nil, weight: nil, inventory_quantity: quantity)], images: nil, image: ProductImage(id: nil, productID: productID, position: nil, width: nil, height: nil, src: imageUrlString))
            print("Data \(productID) ====================")
        }
        
        guard let productDetails = productData else {return}
        // should be data type of Product
        if(UserDefaultsHelper.shared.isDataFound(key: UserDefaultsConstants.isLoggedIn.rawValue)){
            guard let orderID = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.getDraftOrder.rawValue) else {
                return
            }
            customerID = UserDefaultsHelper.shared.getLoggedInUserID()
            guard customerID != nil else { return }
            if(orderID != 0) {
                print("User has Draft order append items and post it \(orderID)")
                viewModel.updateCustomerDraftOrder(orderID: orderID, customerID: customerID!, newProduct: productDetails)
            }else{
                print("Create draft order user doesnt have one ")
                viewModel.createNewDraftOrderAndPostNewItem(customerID: customerID!, product: productDetails)
            }
        }else{
            showAlertError(err: "You have to logged in first")
        }
    }
        
    func showDeleteConfirmationAlert(productId: Int, customerId: Int, indexPath: IndexPath) {
        Constants.showAlertWithAction(on: self, title: "Confirm Delete", message: "Are you sure you want to delete this item?", isTwoBtn: true, firstBtnTitle: "Cancel", actionBtnTitle: "Delete", style: .destructive) { _ in
            self.deleteProduct(productId: productId, customerId: customerId, indexPath: indexPath)
        }
    }

    func deleteProduct(productId: Int, customerId: Int, indexPath: IndexPath) {
        FavoriteCoreData.shared.deleteFromCoreData(productId: productId, customerId: customerId)
        var updatedProducts = favoriteProducts.value
        updatedProducts.remove(at: indexPath.row)
        favoriteProducts.accept(updatedProducts)
        
        updateEmptyStateVisibility()
    }
        
    func navigateToProductDetail(product: [String: Any]) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let productDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController {
            productDetailVC.productId = product["id"] as? Int
            navigationController?.pushViewController(productDetailVC, animated: true)
        }
    }

    private func addToCartObserversFuncs(){
        onErrorObserverSetUp()
        onResponseObserverSetUp()
    }
    private func onErrorObserverSetUp(){
        viewModel?.error.subscribe{ err in
            self.showAlertError(err: err.error?.localizedDescription ?? "Error")
        }.disposed(by: disposeBag)
    }
    private func onResponseObserverSetUp(){
        viewModel?.draftOrder.subscribe(onNext: { [weak self] draftResponse in
            guard let self = self else { return }
            //print("productItem.subscribe \(draftResponse)")
            guard let id = draftResponse.id else {
                return
            }
            UserDefaultsHelper.shared.setIfDataFound(id, key: UserDefaultsConstants.getDraftOrder.rawValue)
            print("Draft order created \(id)")
            Constants.displayAlert(viewController: self, message: "Product Added To cart Successfully", seconds: 1.0)
        }, onError: { error in
            print("Error subscribing to draft order: \(error)")
        }).disposed(by: disposeBag)
    }
    
    private func showAlertError(err:String){
        Constants.displayAlert(viewController: self,message: err, seconds: 3)
    }
    
}

extension FavoriteViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = favoriteProducts.value.count
        if count == 0 {
            favoriteTableView.backgroundView = emptyStateImageView
        } else {
            favoriteTableView.backgroundView = nil
        }
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Configuring cell for row \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        let product = favoriteProducts.value[indexPath.row]
        
        if let title = product["title"] as? String,
           let price = product["price"] as? String,
           let imageUrlString = product["image"] as? String,
           let imageUrl = URL(string: imageUrlString) {
            cell.productNameLabel.text = title
            let convertedPrice = convertPrice(price: price, rate: self.rate ?? 3.3)
            cell.productPriceLabel.text = "\(String(format: "%.2f", convertedPrice)) \(userCurrency)"
            cell.productImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "AppIcon"))
        }
        cell.productQuantityLabel.text = "1"
        cell.productVarintLabel.text = product["variant"] as? String
        
        cell.decreaseQuantityBtn.isHidden = true
        cell.IncreaseQuantityBtn.isHidden = true
        cell.productQuantityLabel.isHidden = true
        
        let addToCartBtn = UIButton(type: .system)
        addToCartBtn.setTitle("Add To Cart", for: .normal)
        addToCartBtn.backgroundColor = .black
        addToCartBtn.setTitleColor(.white, for: .normal)
        addToCartBtn.layer.cornerRadius = 10
        
        cell.contentView.addSubview(addToCartBtn)
        
        addToCartBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addToCartBtn.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 220),
            addToCartBtn.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            addToCartBtn.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -18),
            addToCartBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        addToCartBtn.tag = indexPath.row
        addToCartBtn.addTarget(self, action: #selector(addToCartButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, view, completionHandler) in
            if let productId = self.favoriteProducts.value[indexPath.row]["id"] as? Int, let customerId = self.getLoggedInUserID() {
                self.showDeleteConfirmationAlert(productId: productId, customerId: customerId, indexPath: indexPath)
            }
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor(named: "btnColor") ?? .black
        
        let trashIcon = UIImage(systemName: "trash")?.withTintColor(UIColor(named: "theme") ?? .black, renderingMode: .alwaysOriginal)
        deleteAction.image = trashIcon
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
    
    
    
    // MARK: - empty case
        
    private func setupEmptyStateUI() {
        emptyStateImageView = UIImageView(image: UIImage(named: "emptybox"))
        emptyStateImageView.contentMode = .scaleAspectFit

        emptyStateLabel = UILabel()
        emptyStateLabel.text = "Your Wishlist is empty!"
        emptyStateLabel.font = UIFont(name: "Palatino", size: 20)
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.textColor = .black

        emptyStateSubLabel = UILabel()
        emptyStateSubLabel.text = "Tab heart button to start saving your favorite items."
        emptyStateLabel.font = UIFont(name: "Palatino", size: 16)
        emptyStateSubLabel.textAlignment = .center
        emptyStateSubLabel.numberOfLines = 0
        emptyStateSubLabel.textColor = .gray
        
        let stackView = UIStackView(arrangedSubviews: [emptyStateImageView, emptyStateLabel,emptyStateSubLabel])
        stackView.axis = .vertical
        stackView.spacing = 16.0
        stackView.alignment = .center
        
        favoriteTableView.backgroundView = stackView
        

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: favoriteTableView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: favoriteTableView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: favoriteTableView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: favoriteTableView.trailingAnchor, constant: -16)
        ])
    }

    private func updateEmptyStateVisibility() {
        favoriteTableView.backgroundView?.isHidden = !favoriteProducts.value.isEmpty
    }
}

