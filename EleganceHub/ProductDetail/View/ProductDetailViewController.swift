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
    
    var productItem:Product?
    var disposeBag = DisposeBag()
    
    var colorSelectorView: ColorSelectorView!
        var availableSizes: [String] = []
        var availableColors: [String] = []
        var sizeColorMap: [String: [String]] = [:]
        var selectedSize: String?
        var productId: Int?  // Static product Id
        var viewModel: ProductDetailViewModel!
    
    var customerID:Int?
        var selectedSizeItem:String? = "19"
    
        //var cartViewModel:CartViewModelProtocol?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            //cartViewModel = CartViewModel()
                    
            sizeCollectionView.delegate = self
            sizeCollectionView.dataSource = self
            sizeCollectionView.register(SizeOptionCell.self, forCellWithReuseIdentifier: "SizeOptionCell")
                    
            ProductImagesCollection.delegate = self
            ProductImagesCollection.dataSource = self
            ProductImagesCollection.register(ProductImageCell.self, forCellWithReuseIdentifier: "ProductImageCell")
                    
            if let layout = sizeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
                    
            let networkManager = ProductDetailNetworkService()
            viewModel = ProductDetailViewModel(networkManager: networkManager)
            viewModel.bindingProduct = { [weak self] in
                DispatchQueue.main.async {
                    self?.updateUI()
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
            }
             
            //checkIfUserLoggedIn()
            if let customerID = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.loggedInUserID.rawValue){
                self.customerID = customerID
            }
            addToCartObserversFuncs()
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
        productPrice.text = "$\(product.variants?.first?.price ?? "0.00")"
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
    
    @IBAction func addToFavorite(_ sender: Any) {
        
        guard let product = viewModel.observableProduct else {
                print("No product available to add to favorites.")
                return
            }

            let favoriteData: [String: Any] = [
                "id": product.id ?? 0,
                "customer_id": UserDefaults.standard.integer(forKey: Constants.customerId),
                "variant_id": product.variants?.first?.id ?? 0,
                "title": product.title ?? "",
                "price": product.variants?.first?.price ?? "",
                "image": product.images?.first?.src ?? ""
            ]

            FavoriteCoreData.shared.saveToCoreData([favoriteData]) { success, error in
                if success {
                    print("Product added to favorites.")
                } else {
                    print("Error adding product to favorites: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
            showAlertError(err: "You have to logged in first")
        }
    }
    
    
    private func addToCartObserversFuncs(){
        print("TTTTTTTTTTTTTTT")
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
            Constants.displayToast(viewController: self, message: "Product Added To cart Successfully", seconds: 1.0)
        }, onError: { error in
            print("Error subscribing to draft order: \(error)")
        }).disposed(by: disposeBag)
    }
    
    private func showAlertError(err:String){
        Constants.displayAlert(viewController: self,message: err, seconds: 3)
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
                    self.selectedSizeItem = selectedSize
                    print("selected Size \(selectedSizeItem)")
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
