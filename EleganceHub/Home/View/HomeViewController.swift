//
//  HomeViewController.swift
//  EleganceHub
//
//  Created by raneem on 23/05/2024.
//

import UIKit
import Kingfisher
class HomeViewController: UIViewController {

    
    @IBOutlet weak var brandsCollection: UICollectionView!
    @IBOutlet weak var couponsCollection: UICollectionView!
    
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
            print(brand?.title, brand?.id)
            KF.url(URL(string: brand?.image.src ?? "https://cdn.shopify.com/s/files/1/0880/0426/4211/collections/a340ce89e0298e52c438ae79591e3284.jpg?v=1716276581"))
                .set(to: brandsCell.brandImage)
            
            return brandsCell
        }else {
            let couponsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "couponsCell", for: indexPath) as! CouponsCollectionViewCell
            if(!couponsList!.isEmpty){
                print("!couponsList!.isEmpty")
                couponsCell.couponsLabel.text = couponsList![indexPath.row].code
                couponsCell.codeLabel.text = "Coupons code: \(couponsList?[indexPath.row].code ?? "")"
                if(indexPath.row < couponsList!.count){
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
//        if collectionView == brandsCollection {
//            print("brandsCollection clicked")
//        }else{
//            Constants.displayToast(viewController: self, message: "Coupon code is \(couponsList?[indexPath.row].code ?? "")", seconds: 2.2)
//        }
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == brandsCollection {
//            performSegue(withIdentifier: "goToProducts", sender: nil)
//        }
//    }

}
