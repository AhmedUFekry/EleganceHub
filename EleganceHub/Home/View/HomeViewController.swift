//
//  HomeViewController.swift
//  EleganceHub
//
//  Created by raneem on 23/05/2024.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    @IBOutlet weak var brandsCollection: UICollectionView!
    @IBOutlet weak var couponsCollection: UICollectionView!
    @IBOutlet weak var appBarView: CustomAppBarUIView!
    @IBOutlet weak var pageControl: UIPageControl!

    let numberOfRows: CGFloat = 2
    let spacing: CGFloat = 8

    var cartCountLabel:UILabel = UILabel()
    var favCountLabel:UILabel = UILabel()
    
    var timer: Timer?
    var currentIndex = 0
    
    var favoriteProducts: BehaviorRelay<[[String: Any]]> = BehaviorRelay(value: [])
    private let disposeBag = DisposeBag()
    
    var homeViewModel = HomeViewModel()
    var cartViewModel: CartViewModelProtocol = CartViewModel()

    var smartCollections : SmartCollections?
    var couponsList : [Coupon]? = []
    var couponsImage : [String] = ["10","20","30","40","50","70","sale1"]
    var draftOrder:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        homeViewModel.bindResultToViewController = { [weak self] in
            guard let self = self else {return}
            self.smartCollections = self.homeViewModel.vmResult
            self.renderView()
        }
        
        homeViewModel.bindCouponsToViewController = {[weak self] in
            guard let self = self else {return}
            self.couponsList = self.homeViewModel.couponsResult!
            self.pageControl.numberOfPages = self.couponsList?.count ?? 1

            self.renderView()
        }
        
        homeViewModel.failureIngetData = { faildMsg in
            Constants.displayAlert(viewController: self, message: faildMsg, seconds: 2.2)
        }
       
        setupCollectionView()
        orderDraft()
        
        pageControl.currentPage = currentIndex
        startAutoScrolling()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeViewModel.getBrandsFromModel()
        homeViewModel.getCouponsFromModel()
        checkIfUserLoggedIn()
        setupBadgeLabel(on:appBarView.secoundTrailingIcon,badgeLabel: cartCountLabel)
        setupBadgeLabel(on:appBarView.trailingIcon,badgeLabel: favCountLabel)
        
        draftOrder = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.getDraftOrder.rawValue)
        if draftOrder != 0 {
            cartViewModel.getDraftOrderForUser(orderID: draftOrder!)
        }
        loadFavoriteProducts()

        showCountOnCartData()
        applySavedTheme()
        
    }
    
    private func applySavedTheme() {
        if #available(iOS 13.0, *) {
            let appDelegate = UIApplication.shared.windows.first
            let isDarkMode = UserDefaultsHelper.shared.isDarkMode()
            appDelegate?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        }
    }
    private func setUpUI(){
        let searchIcon = UIImage(systemName: "magnifyingglass")?.withTintColor(UIColor(named: "btnColor") ?? .black, renderingMode: .alwaysOriginal)
        let cartIcon = UIImage(systemName: "cart.circle")?.withTintColor(UIColor(named: "btnColor") ?? .black, renderingMode: .alwaysOriginal)
        let heartIcon = UIImage(systemName: "heart.circle")?.withTintColor(UIColor(named: "btnColor") ?? .black, renderingMode: .alwaysOriginal)
        self.appBarView.backBtn.setImage(searchIcon, for: .normal)
        
        self.appBarView.secoundTrailingIcon.setImage(cartIcon, for: .normal)
        self.appBarView.trailingIcon.setImage(heartIcon, for: .normal)
        
        self.appBarView.backBtn.addTarget(self, action: #selector(onSearchTapped), for: .touchUpInside)
        self.appBarView.lableTitle.text = "Home"
    }
    
    private func orderDraft(){
        print("hiiiiiiiiiii")
        homeViewModel.draftOrderID.subscribe(onNext:{ value in
            if(value == 0){
                print("order ID not founddd \(value) and Order ID is \(UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.getDraftOrder.rawValue))")
            }else{
                UserDefaultsHelper.shared.setIfDataFound(value, key: UserDefaultsConstants.getDraftOrder.rawValue)
                print("order ID \(value)")
                
            }
        }).disposed(by: disposeBag)
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
        
    @objc private func onButtonSelected() {
        Constants.showAlertWithAction(on: self, title: "Login Required", message: "You need to login to access this feature.", isTwoBtn: true, firstBtnTitle: "Cancel", actionBtnTitle: "Login") { [weak self] _ in
            guard let viewController = self else { return }
            if let newViewController = viewController.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
                newViewController.hidesBottomBarWhenPushed = true
                viewController.navigationController?.pushViewController(newViewController, animated: true)
            }
        }
    }

    func renderView(){
        DispatchQueue.main.async {
            self.brandsCollection.reloadData()
            self.couponsCollection.reloadData()
        }
    }
    @objc private func onCartTapped(){
        print("cartBtn \(couponsList?.count ?? 0)")
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
            print("cartBtn CartViewController")
                self.navigationController?.pushViewController(viewController, animated: true)
            } else {
                print("Failed to instantiate CartViewController")
            }
    }
    
    @objc private func onFavouriteTapped(){
        if let favoriteViewController = storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as? FavoriteViewController {
                navigationController?.pushViewController(favoriteViewController, animated: true)
        } else {
            print("Failed to instantiate FavoriteViewController")
        }
    }
    @objc private func onSearchTapped(){
        let searchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
        searchViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    private func setupCollectionView() {
        
        let couponsNibCell = UINib(nibName: "CouponsCollectionViewCell", bundle: nil)
        couponsCollection.register(couponsNibCell, forCellWithReuseIdentifier: "couponsCell")
        
        let brandsNibCell = UINib(nibName: "BrandsCollectionViewCell", bundle: nil)
        brandsCollection.register(brandsNibCell, forCellWithReuseIdentifier: "brandsCell")
        
        let couponsLayout = UICollectionViewFlowLayout()
        couponsLayout.scrollDirection = .horizontal
        couponsLayout.itemSize = CGSize(width: couponsCollection.frame.width + 4, height: couponsCollection.frame.height + 4)
        couponsCollection.collectionViewLayout = couponsLayout
        couponsCollection.layer.borderWidth = 2.0
        couponsCollection.layer.cornerRadius = 10
        couponsCollection.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        let brandsLayout = UICollectionViewFlowLayout()
        brandsLayout.scrollDirection = .horizontal

        let itemWidth = (brandsCollection.frame.width / 2) - (spacing * 2)
        let itemHeight = (brandsCollection.frame.height / numberOfRows) - spacing
        brandsLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        brandsCollection.collectionViewLayout = brandsLayout
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let layout = couponsCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: couponsCollection.frame.width + 4, height: couponsCollection.frame.height + 4)
            layout.invalidateLayout()
        }
        if let brandLayout = brandsCollection.collectionViewLayout as? UICollectionViewFlowLayout{
            brandLayout.itemSize =  CGSize(width: (brandsCollection.frame.width / 2) - (spacing * 2), height: (brandsCollection.frame.height / numberOfRows) - spacing)
            brandLayout.invalidateLayout()
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
    
    func startAutoScrolling() {
           timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextItem), userInfo: nil, repeats: true)
       }
    
    @objc func scrollToNextItem() {
        let itemCount = couponsCollection.numberOfItems(inSection: 0)
        if itemCount == 0 { return }
        
        currentIndex += 1
        if currentIndex >= itemCount {
            currentIndex = 0
        }
        
        let indexPath = IndexPath(item: currentIndex, section: 0)
        couponsCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    deinit {
       timer?.invalidate()
   }
}
extension HomeViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == couponsCollection){
            return couponsList?.count ?? 2
        }else{
            return smartCollections?.smartCollections.count ?? 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == brandsCollection {
            let brandsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "brandsCell", for: indexPath) as! BrandsCollectionViewCell
            let brand = smartCollections?.smartCollections[indexPath.row]
            
            brandsCell.brandName?.text = brand?.title
            KF.url(URL(string: brand?.image.src ?? "https://cdn.shopify.com/s/files/1/0880/0426/4211/collections/a340ce89e0298e52c438ae79591e3284.jpg?v=1716276581"))
                .set(to: brandsCell.brandImage)
            
            return brandsCell
        }else {
            let couponsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "couponsCell", for: indexPath) as! CouponsCollectionViewCell
            if(!couponsList!.isEmpty){
                print("!couponsList!.isEmpty")
                //couponsCell.couponsLabel.isHidden = true
                couponsCell.codeLabel.text = "Coupons code: \(couponsList?[indexPath.row].discountCode.code ?? "")"
                if(indexPath.row < couponsImage.count){
                    //var index = 0
                    couponsCell.couponsImage.image = UIImage(named:setBackGround(discountValue: couponsList?[indexPath.row].priceRule ?? 0) )
                }else{
                    couponsCell.couponsImage.image = UIImage(named: couponsImage[3])
                }
            }
            return couponsCell
        }
    }
    
    func setBackGround(discountValue:Int) -> String{
        switch discountValue{
        case 10:
            return "101"
        case 20:
            return "201"
        case 30:
            return "301"
        case 40:
            return "40"
        case 50:
            return "50"
        case 70:
            return "70"
        default:
            return "sale1"
        }
    
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == brandsCollection{
            let brand = smartCollections?.smartCollections[indexPath.row]
            if let ProductViewController = storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as? ProductViewController {
                if collectionView == brandsCollection {
                    ProductViewController.brandsId = brand?.id
                    ProductViewController.brandsName = brand?.title

                    navigationController?.pushViewController(ProductViewController, animated: true)
                }
            }
        }else{
            guard let cell = couponsCollection.cellForItem(at: indexPath) as? CouponsCollectionViewCell else {return}
            if let coppiedText = couponsList?[indexPath.row].discountCode.code {
                UIPasteboard.general.string = coppiedText
                Constants.displayAlert(viewController: self, message: "The content has been copied to the clipboard.", seconds: 1.0)
            }
        }
        couponsCollection.deselectItem(at: indexPath, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == couponsCollection {
//               return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
//        }
//        return CGSize(width: 180, height: 120)
//    }
    
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == couponsCollection {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = page
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == couponsCollection {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = page
        }
    }
}
