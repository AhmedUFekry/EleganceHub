//
//  HomeViewController.swift
//  EleganceHub
//
//  Created by raneem on 23/05/2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var brandsCollection: UICollectionView!
    
    @IBOutlet weak var couponsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let couponsNibCell = UINib(nibName: "CouponsCollectionViewCell", bundle: nil)
        couponsCollection.register(couponsNibCell, forCellWithReuseIdentifier: "couponsCell")
        
        let brandsNibCell = UINib(nibName: "BrandsCollectionViewCell", bundle: nil)
        brandsCollection.register(brandsNibCell, forCellWithReuseIdentifier: "brandsCell")
        
      

        setupCollectionView()
    }
    
    
    
    private func setupCollectionView() {
        
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
}
extension HomeViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == couponsCollection){
            return 10
        }else{
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == brandsCollection {
            let brandsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "brandsCell", for: indexPath) as! BrandsCollectionViewCell
            
            return brandsCell
        } else {
            let couponsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "couponsCell", for: indexPath) as! CouponsCollectionViewCell
            return couponsCell
        }
    }
}
