//
//  SuperCategoryViewController.swift
//  EleganceHub
//
//  Created by raneem on 01/06/2024.
//

import UIKit
import Kingfisher
import JJFloatingActionButton
import RxSwift
import RxCocoa


class SuperCategoryViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categorySearchBar: UISearchBar!
    @IBOutlet weak var segmentCategory: UISegmentedControl!
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var appBarView: CustomAppBarUIView!
    
    var favoriteProducts: BehaviorRelay<[[String: Any]]> = BehaviorRelay(value: [])
    
    let categoryViewModel = CategoryViewModel()
    let productsViewModel = CurrencyViewModel()
    var categoryProductList: [Product]?
    var filteredList: [Product]?
    var searchList: [Product]?
    var userCurrency:String?
    var isFiltered: Bool = false
    var isSearching: Bool = false
    private let disposeBag = DisposeBag()

    var rate : Double!
    var draftOrder:Int?
    
    var homeViewModel = HomeViewModel()
    var cartViewModel: CartViewModelProtocol = CartViewModel()

    var cartCountLabel:UILabel = UILabel()
    var favCountLabel:UILabel = UILabel()
      
       override func viewDidLoad() {
           super.viewDidLoad()
           
        activityIndicator.startAnimating()

        loadNib()
        categorySearchBar.delegate = self
        categoryViewModel.bindResultToViewController = { [weak self] in
            guard let self = self else { return }
            self.categoryProductList = self.categoryViewModel.categoryResult
            self.renderView()
        }
           setUpUI()
        displayFloatingButton()
        categoryViewModel.getCategoryProducts(category: .Women)
       setupBadgeLabel(on:appBarView.secoundTrailingIcon,badgeLabel: cartCountLabel)
       setupBadgeLabel(on:appBarView.trailingIcon,badgeLabel: favCountLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfUserLoggedIn()
        self.renderView()
        userCurrency = UserDefaultsHelper.shared.getCurrencyFromUserDefaults().uppercased()
        productsViewModel.rateClosure = {
            [weak self] rate in
            DispatchQueue.main.async {
                self?.rate = rate
            }
        }
        productsViewModel.getRate()
        
        
        draftOrder = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.getDraftOrder.rawValue)
        if draftOrder != 0 {
            cartViewModel.getDraftOrderForUser(orderID: draftOrder!)
        }
        loadFavoriteProducts()

        showCountOnCartData()
    }
    private func setUpUI(){
        let cartIcon = UIImage(systemName: "cart.circle")?.withTintColor(UIColor(named: "btnColor") ?? .black, renderingMode: .alwaysOriginal)
        let heartIcon = UIImage(systemName: "heart.circle")?.withTintColor(UIColor(named: "btnColor") ?? .black, renderingMode: .alwaysOriginal)
        self.appBarView.backBtn.isHidden = true
        
        self.appBarView.secoundTrailingIcon.setImage(cartIcon, for: .normal)
        self.appBarView.trailingIcon.setImage(heartIcon, for: .normal)
        
        self.appBarView.lableTitle.text = "Category"
    }
    
    @objc private func onButtonSelected() {
        Constants.showAlertWithAction(on: self, title: "Login Required", message: "You need to login to access this feature.", isTwoBtn: true, firstBtnTitle: "Cancel", actionBtnTitle: "Login") { [weak self] _ in
            guard let viewController = self else { return }
            if let newViewController = viewController.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
                newViewController.hidesBottomBarWhenPushed = true
                viewController.navigationController?.pushViewController(newViewController, animated: true)
            }
        }
    }
    
    func getLoggedInUserID() -> Int? {
        return UserDefaultsHelper.shared.getLoggedInUserID()
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
    private func showCountOnCartData() {
        cartViewModel.lineItemsList
            .map{ $0.count }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] count in
                guard let self = self else { return }
                self.cartCountLabel.isHidden = count == 0
                if count > 0 {
                    self.cartCountLabel.text = "\(count)"
                }
            })
            .disposed(by: disposeBag)
        
        favoriteProducts.map{ $0.count }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] count in
                guard let self = self else { return }
                self.favCountLabel.isHidden = count == 0
                if count > 0 {
                    self.favCountLabel.text = "\(count)"
                }
                print("Fav count \(count)")
            })
            .disposed(by: disposeBag)
    }
    
    func loadNib() {
        let categoryNibCell = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        categoryCollection.register(categoryNibCell, forCellWithReuseIdentifier: "CategoryCell")
    }
    
    func renderView() {
        DispatchQueue.main.async {
            self.categoryCollection.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    @IBAction func segmentChanges(_ sender: Any) {
        switch(segmentCategory.selectedSegmentIndex) {
        case 0:
            categoryViewModel.getCategoryProducts(category: .Women)
        case 1:
            categoryViewModel.getCategoryProducts(category: .Men)
        case 2:
            categoryViewModel.getCategoryProducts(category: .Kids)
        case 3:
            categoryViewModel.getCategoryProducts(category: .Sale)
        default:
            break
        }
        categoryCollection.reloadData()
    }
    
    @objc private func onFavouriteTapped(){
        if let favoriteViewController = storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as? FavoriteViewController {
                navigationController?.pushViewController(favoriteViewController, animated: true)
        } else {
            print("Failed to instantiate FavoriteViewController")
        }
    }
    
    private func checkIfUserLoggedIn(){
        if(UserDefaultsHelper.shared.isDataFound(key: UserDefaultsConstants.isLoggedIn.rawValue)){
            
            guard let customerID = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.loggedInUserID.rawValue) else {
                print("Customer id not found")
                return
            }
            homeViewModel.checkIfUserHasDraftOrder(customerID: customerID)
            print("Customer id found \(customerID)")
            self.self.appBarView.secoundTrailingIcon.addTarget(self, action: #selector(onCartTapped), for: .touchUpInside)
            self.self.appBarView.trailingIcon.addTarget(self, action: #selector(onFavouriteTapped), for: .touchUpInside)
        } else {
            self.self.appBarView.secoundTrailingIcon.addTarget(self, action: #selector(onButtonSelected), for: .touchUpInside)
            self.self.appBarView.trailingIcon.addTarget(self, action: #selector(onButtonSelected), for: .touchUpInside)
        }
    }
    
    @objc private func onCartTapped(){
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
            print("cartBtn CartViewController")
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            print("Failed to instantiate CartViewController")
        }
    }
    
    func displayFloatingButton() {
        let actionButton = JJFloatingActionButton()
        actionButton.buttonColor = UIColor.black
        actionButton.buttonImage = UIImage(named: "menu")
        
        actionButton.addItem(title: "All", image: UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate)) { item in
            self.isFiltered = false
            self.renderView()
        }
        actionButton.addItem(title: "Shoes", image: UIImage(named: "shoes")?.withRenderingMode(.alwaysTemplate)) { item in
            self.isFiltered = true
            self.filteredList = self.categoryViewModel.filterCategory(filterType: "SHOES")
            self.renderView()
        }
        actionButton.addItem(title: "T-Shirts", image: UIImage(named: "tshirt")?.withRenderingMode(.alwaysTemplate)) { item in
            self.isFiltered = true
            self.filteredList = self.categoryViewModel.filterCategory(filterType: "T-SHIRTS")
            self.renderView()
        }
        actionButton.addItem(title: "Accessories", image: UIImage(named: "Accsesory")?.withRenderingMode(.alwaysTemplate)) { item in
            self.isFiltered = true
            self.filteredList = self.categoryViewModel.filterCategory(filterType: "ACCESSORIES")
            self.renderView()
        }
        actionButton.display(inViewController: self)
    }
}

//MARK: CollectionViewDataSource & CollectionViewDelegate
extension SuperCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return searchList?.count ?? 0
        } else if isFiltered {
            return filteredList?.count ?? 0
        } else {
            return categoryProductList?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        let category = isSearching ? searchList?[indexPath.row] : (isFiltered ? filteredList?[indexPath.row] : categoryProductList?[indexPath.row])
        
        categoryCell.categoryTitle?.text = category?.title
        KF.url(URL(string: category?.image?.src ?? "https://cdn.shopify.com/s/files/1/0880/0426/4211/collections/a340ce89e0298e52c438ae79591e3284.jpg?v=1716276581"))
            .set(to: categoryCell.categoryImage)
        categoryCell.categoryType?.text = category?.productType
       // categoryCell.categoryPrice?.text = category?.variants?[0].price
        
        let convertedPrice = convertPrice(price: category?.variants?[0].price ?? "2", rate: self.rate)
                       
        categoryCell.categoryPrice.text = "\(String(format: "%.2f", convertedPrice)) \(userCurrency!)"
        return categoryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 0
        let collectionViewSize = collectionView.frame.size.width - padding
        let width = collectionViewSize / 2
        let height = width
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let productDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController else {
            return
        }
        
        let product = getProductForIndexPath(indexPath)
        
        productDetailVC.productId = product?.id ?? -404
        
        navigationController?.pushViewController(productDetailVC, animated: true)
    }

    private func getProductForIndexPath(_ indexPath: IndexPath) -> Product? {
        if isSearching {
            return searchList?[indexPath.row]
        } else if isFiltered {
            return filteredList?[indexPath.row]
        } else {
            return categoryProductList?[indexPath.row]
        }
    }


}

//MARK: UISearchBarDelegate
extension SuperCategoryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            searchList = nil
        } else {
            isSearching = true
            searchList = categoryProductList?.filter { $0.title?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
        renderView()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        searchList = nil
        renderView()
    }
    
    func setupBadgeLabel(on button: UIButton, badgeLabel:UILabel) {
        badgeLabel.backgroundColor = .red
        badgeLabel.textColor = .white
        badgeLabel.font = .systemFont(ofSize: 16)
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 10
        badgeLabel.clipsToBounds = true
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.isHidden = true
        //badgeLabel.text = "10"
        button.addSubview(badgeLabel)
        
        NSLayoutConstraint.activate([
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 20),
            badgeLabel.heightAnchor.constraint(equalToConstant: 20),
            badgeLabel.topAnchor.constraint(equalTo: button.topAnchor, constant: -5),
            badgeLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 5)
        ])
    }
    
}



