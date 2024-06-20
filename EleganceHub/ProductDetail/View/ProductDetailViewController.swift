//
//  ProductDetailViewController.swift
//  EleganceHub
//
//  Created by Shimaa on 03/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var colorSelectorContainer: UIView!
    
    @IBOutlet weak var imageSlider: UIPageControl!
    @IBOutlet weak var ProductImagesCollection: UICollectionView!
    
    @IBOutlet weak var ProductName: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var ProductDescription: UILabel!
    @IBOutlet weak var addToCartBtn: UIButton!
    let networkManager = ProductDetailNetworkService()
    var productItem:Product?
    var disposeBag = DisposeBag()
    @IBOutlet weak var appBarView: CustomAppBarUIView!
    
    var colorSelectorView: ColorSelectorView!
    var availableSizes: [String] = []
    var availableColors: [String] = []
    var sizeColorMap: [String: [String]] = [:]
    var selectedSize: String?
    var productId: Int?
    var viewModel: ProductDetailViewModel!
    
    var customerID:Int?
    var selectedSizeItem:String? = "19"
    
    var currencyViewModel = CurrencyViewModel()
    var rate : Double!
    
    let userCurrency = UserDefaultsHelper.shared.getCurrencyFromUserDefaults().uppercased()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyViewModel.rateClosure = {
            [weak self] rate in
            DispatchQueue.main.async {
                self?.rate = rate
            }
        }
        currencyViewModel.getRate()
        setUpUI()
                    
        let networkManager = ProductDetailNetworkService()
        viewModel = ProductDetailViewModel(networkManager: networkManager)
        viewModel.bindingProduct = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
            
            if let customerID = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.loggedInUserID.rawValue){
                self?.customerID = customerID
            }
        }
        
        addToCartObserversFuncs()
        
        if let productId = productId {
            viewModel.getProductDetails(productId: productId)
            viewModel.getAvailableVarients(productId: productId) { [weak self] sizeColorMap, colors in
                guard let self = self else { return }
                
                self.sizeColorMap = sizeColorMap
                self.availableColors = colors
                self.availableSizes = Array(sizeColorMap.keys)
                
                self.sizeCollectionView.reloadData()
                self.setupColorSelectorView()
            }
        } else {
            print("Product ID is nil.")
            
            
            if let productId = productId {
                viewModel.getProductDetails(productId: productId)
                viewModel.getAvailableVarients(productId: productId) { [weak self] sizeColorMap, colors in
                    guard let self = self else { return }
                    
                    self.sizeColorMap = sizeColorMap
                    self.availableColors = colors
                    self.availableSizes = Array(sizeColorMap.keys)
                    
                    self.sizeCollectionView.reloadData()
                    self.setupColorSelectorView()
                }
                
                print("Checking if product is in favorites...")
                if let productName = viewModel.observableProduct?.title {
                    let customerId = UserDefaultsHelper.shared.getLoggedInUserID()
                    print("User ID: \(customerId)")
                    let isFavorite = FavoriteCoreData.shared.isProductInFavorites(productId: productId, productName: productName)
                    print("Product \(productName) with ID \(productId) is favorite: \(isFavorite)")
                    updateFavoriteButton(isFavorite: isFavorite)
                }
            }
        }
    
        if let customerID = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.loggedInUserID.rawValue){
            self.customerID = customerID
        }
        addToCartObserversFuncs()
    }
    private func setUpUI(){
        sizeCollectionView.delegate = self
        sizeCollectionView.dataSource = self
        sizeCollectionView.register(SizeOptionCell.self, forCellWithReuseIdentifier: "SizeOptionCell")
                
        ProductImagesCollection.delegate = self
        ProductImagesCollection.dataSource = self
        ProductImagesCollection.register(ProductImageCell.self, forCellWithReuseIdentifier: "ProductImageCell")
                
        if let layout = sizeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        self.appBarView.secoundTrailingIcon.isHidden = true
        self.appBarView.trailingIcon.setImage(UIImage(named: "fav"), for: .normal)
        self.appBarView.lableTitle.text = "Product Details"
        
        self.appBarView.trailingIcon.addTarget(self, action: #selector(onFavouriteTapped), for: .touchUpInside)
        self.appBarView.backBtn.addTarget(self, action: #selector(bakBtnTapped), for: .touchUpInside)
        
    }
    
    private func updateUI() {
        guard let product = viewModel.observableProduct else {
            print("Observable product is nil.")
            return
        }
        productItem = product
        
        print("Product Title: \(product.title ?? "No title")")
        print("Product Price: \(product.variants?.first?.price ?? "No price")")
        print("Product Description: \(product.bodyHTML ?? "No description")")
        
        ProductName.text = product.title ?? "No title"
        //productPrice.text = "$\(product.variants?.first?.price ?? "0.00")"
        
        var convertedPrice = convertPrice(price: product.variants?[0].price ?? "2", rate: self.rate)
        productPrice.text = "\(String(format: "%.2f", convertedPrice)) \(userCurrency)"
        
        ProductDescription.text = product.bodyHTML ?? "No description"
        ProductImagesCollection.reloadData()
        imageSlider.numberOfPages = product.images?.count ?? 0
    }
    
    private func setupColorSelectorView(filteredColors: [String]? = nil) {
        colorSelectorView?.removeFromSuperview()
        
        if let filteredColors = filteredColors {
            let dynamicColors: [UIColor] = filteredColors.map { color in
                return colorToUIColor(color)
            }
            
            colorSelectorView = ColorSelectorView(colors: dynamicColors)
        } else {
            let dynamicColors: [UIColor] = availableColors.map { color in
                return colorToUIColor(color)
            }
            
            colorSelectorView = ColorSelectorView(colors: dynamicColors)
        }
        
        colorSelectorView.translatesAutoresizingMaskIntoConstraints = false
        colorSelectorContainer.addSubview(colorSelectorView)
        
        NSLayoutConstraint.activate([
            colorSelectorView.leadingAnchor.constraint(equalTo: colorSelectorContainer.leadingAnchor),
            colorSelectorView.trailingAnchor.constraint(equalTo: colorSelectorContainer.trailingAnchor),
            colorSelectorView.topAnchor.constraint(equalTo: colorSelectorContainer.topAnchor),
            colorSelectorView.bottomAnchor.constraint(equalTo: colorSelectorContainer.bottomAnchor)
        ])
    }
    
    private func colorToUIColor(_ color: String) -> UIColor {
        switch color.lowercased() {
        case "black":
            return .black
        case "green":
            return .green
        case "red":
            return .red
        case "blue":
            return .blue
        case "brown":
            return .brown
        case "purple":
            return .purple
        case "orange":
            return .orange
        case "white":
            return .white
        case "yellow":
            return .yellow
        default:
            return .gray
        }
    }
    
    @objc func onFavouriteTapped() {
        guard let customerId = getCustomerId() else {
            Constants.showAlertWithAction(on: self, title: "Login Required", message: "You need to login to access this feature.", isTwoBtn: true, firstBtnTitle: "Cancel", actionBtnTitle: "Login") { [weak self] _ in
                guard let viewController = self else { return }
                if let newViewController = viewController.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
                    newViewController.hidesBottomBarWhenPushed = true
                    viewController.navigationController?.pushViewController(newViewController, animated: true)
                }
            }
            return
        }
            
        guard let product = getProduct() else {
            print("No product available to add to favorites.")
            return
        }
        
        addToFavorites(product: product, customerId: customerId)
    }
    
    @objc func bakBtnTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    

    private func addToFavorites(product: Product, customerId: Int) {
        let productId = product.id ?? 0
        let productName = product.title ?? ""
        if checkIfFavorite(productId: productId, productName: productName) {
            print("Product \(productName) with ID \(productId) is already in favorites.")
            return
        }
        
        let productData: [String: Any] = [
            "id": productId,
            "variant_id": product.variants?.first?.id ?? 0,
            "title": productName,
            "price": product.variants?.first?.price ?? "",
            "image": product.images?.first?.src ?? "",
            "inventory_quantity": product.variants?.first?.inventory_quantity ?? 0,
            "product_type": product.productType ?? ""
        ]
        
        FavoriteCoreData.shared.saveToCoreData([productData]) { success, error in
            if let error = error {
                print("Error saving product to favorites: \(error.localizedDescription)")
               
            } else if success {
                print("Product \(productName) with ID \(productId) saved to favorites.")
            }
        }
    }
    
    private func getProduct() -> Product? {
        return viewModel.observableProduct
    }
    
    private func getCustomerId() -> Int? {
        return UserDefaultsHelper.shared.getLoggedInUserID()
    }
    
    private func checkIfFavorite(productId: Int, productName: String) -> Bool {
        return FavoriteCoreData.shared.isProductInFavorites(productId: productId, productName: productName)
    }
    
    private func removeFromFavorites(productId: Int, customerId: Int) {
        FavoriteCoreData.shared.deleteFromCoreData(productId: productId, customerId: customerId)
        updateFavoriteButton(isFavorite: false)
        print("Product removed from favorites.")
    }
    

    private func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        self.appBarView.trailingIcon.setImage(UIImage(systemName: imageName), for: .normal)
        self.appBarView.trailingIcon.isEnabled = getCustomerId() != nil
    }
    
    
    @IBAction func addToCartBtn(_ sender: UIButton) {
        if(UserDefaultsHelper.shared.isDataFound(key: UserDefaultsConstants.isLoggedIn.rawValue)){
            guard let productItem = productItem else {
                return
            }
            guard let orderID = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.getDraftOrder.rawValue) else {
                return
            }
            if(orderID != 0) {
                print("User has Draft order append items and post it \(orderID)")
                viewModel.updateCustomerDraftOrder(orderID: orderID, customerID: customerID!, newProduct: productItem)
            }else{
                print("Create draft order user doesnt have one ")
                viewModel.createNewDraftOrderAndPostNewItem(customerID: customerID!, product: productItem)
            }
        }else{
            Constants.showAlertWithAction(on: self, title: "Login Required", message: "You need to login to access this feature.", isTwoBtn: true, firstBtnTitle: "Cancel", actionBtnTitle: "Login") { [weak self] _ in
                guard let viewController = self else { return }
                if let newViewController = viewController.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
                    newViewController.hidesBottomBarWhenPushed = true
                    viewController.navigationController?.pushViewController(newViewController, animated: true)
                }
            }
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
    
    
    @IBAction func navigateToReviews(_ sender: Any) {
        if let reviewViewController = storyboard?.instantiateViewController(identifier: "ReviewViewController") as? ReviewViewController{
            navigationController?.pushViewController(reviewViewController, animated: true)
        }
    }
}

extension ProductDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == sizeCollectionView {
        return availableSizes.count
    } else {
        return viewModel.observableProduct?.images?.count ?? 0
    }
}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sizeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeOptionCell", for: indexPath) as! SizeOptionCell
            cell.sizeLabel.text = availableSizes[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath) as! ProductImageCell
            if let imageUrlString = viewModel.observableProduct?.images?[indexPath.row].src, let imageUrl = URL(string: imageUrlString) {
                cell.productImageView.loadImage(from: imageUrl)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sizeCollectionView {
            selectedSize = availableSizes[indexPath.row]
            if let selectedSize = selectedSize, let colorsForSelectedSize = sizeColorMap[selectedSize] {
                setupColorSelectorView(filteredColors: colorsForSelectedSize)
            } else {
                setupColorSelectorView()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == sizeCollectionView {
            return CGSize(width: 50, height: 50)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == ProductImagesCollection {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
            imageSlider.currentPage = page
        }
    }
}
