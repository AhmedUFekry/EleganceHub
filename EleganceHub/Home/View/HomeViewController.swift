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
    @IBOutlet weak var cartBtn:UIBarButtonItem!
    @IBOutlet weak var favBtn: UIBarButtonItem!
    
    private let disposeBag = DisposeBag()
    
    var homeViewModel = HomeViewModel()
    var smartCollections : SmartCollections?
    var couponsList : [DiscountCodes]? = []
    var couponsImage : [String] = ["discount_1","discount_2","discount_3","discount_4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeViewModel.bindResultToViewController = { [weak self] in
            guard let self = self else {return}
            self.smartCollections = self.homeViewModel.vmResult
            self.renderView()
        }
        
        homeViewModel.bindCouponsToViewController = {[weak self] in
            guard let self = self else {return}
            self.couponsList = self.homeViewModel.couponsResult!
            self.renderView()
        }
        
        homeViewModel.failureIngetData = { faildMsg in
            Constants.displayToast(viewController: self, message: faildMsg, seconds: 2.2)
        }

        homeViewModel.getBrandsFromModel()
        homeViewModel.getCouponsFromModel()
        setupCollectionView()
        orderDraft()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkIfUserLoggedIn()
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
            self.cartBtn.isEnabled = true
            self.favBtn.isEnabled = true
            guard let customerID = UserDefaultsHelper.shared.getDataFound(key: UserDefaultsConstants.loggedInUserID.rawValue) else {
                print("Customer id not found ")
                return
            }
            homeViewModel.checkIfUserHasDraftOrder(customerID: customerID)
            print("Customer id found \(customerID)")
            
        }else{
            self.cartBtn.isEnabled = false
            self.favBtn.isEnabled = false
        }
    }
    
    func renderView(){
        DispatchQueue.main.async {
            self.brandsCollection.reloadData()
            self.couponsCollection.reloadData()
        }
    }
    
    private func setupCollectionView() {
        
        let couponsNibCell = UINib(nibName: "CouponsCollectionViewCell", bundle: nil)
        couponsCollection.register(couponsNibCell, forCellWithReuseIdentifier: "couponsCell")
        
        let brandsNibCell = UINib(nibName: "BrandsCollectionViewCell", bundle: nil)
        brandsCollection.register(brandsNibCell, forCellWithReuseIdentifier: "brandsCell")
        
        let couponsLayout = UICollectionViewFlowLayout()
        couponsLayout.scrollDirection = .horizontal
        couponsLayout.itemSize = CGSize(width: view.frame.width, height: 180)
        couponsCollection.collectionViewLayout = couponsLayout
        
        let brandsLayout = UICollectionViewFlowLayout()
        brandsLayout.scrollDirection = .horizontal
        let itemWidth = (view.frame.width / 2) - 15
        brandsLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        brandsCollection.collectionViewLayout = brandsLayout
    }
    

    @IBAction func cartBtn(_ sender: UIBarButtonItem) {
        print("cartBtn \(couponsList?.count ?? 0)")
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
            print("cartBtn CartViewController")
                self.navigationController?.pushViewController(viewController, animated: true)
            } else {
                print("Failed to instantiate CartViewController")
            }
    }
    
    @IBAction func searchBtn(_ sender: UIBarButtonItem) {
        let searchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
        searchViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @IBAction func favoriteBtn(_ sender: Any) {
        if let favoriteViewController = storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as? FavoriteViewController {
                navigationController?.pushViewController(favoriteViewController, animated: true)
        } else {
            print("Failed to instantiate FavoriteViewController")
        }
    }
}
extension HomeViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
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
                couponsCell.couponsLabel.text = couponsList![indexPath.row].code
                couponsCell.codeLabel.text = "Coupons code: \(couponsList?[indexPath.row].code ?? "")"
                if(indexPath.row < couponsImage.count){
                    //var index = 0
                    couponsCell.couponsImage.image = UIImage(named: couponsImage[indexPath.row])
                 //   index += 1
                }else{
                    couponsCell.couponsImage.image = UIImage(named: couponsImage[3])
                }
            }
            return couponsCell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let brand = smartCollections?.smartCollections[indexPath.row]
        if let ProductViewController = storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as? ProductViewController {
            if collectionView == brandsCollection {
                ProductViewController.brandsId = brand?.id
                navigationController?.pushViewController(ProductViewController, animated: true)
            }
        }
    }
}

 
