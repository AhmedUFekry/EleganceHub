//
//  HomeViewController.swift
//  EleganceHub
//
//  Created by raneem on 23/05/2024.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var brandsCollection: UICollectionView!
    
    @IBOutlet weak var CouponsCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
//   let nibCell = UINib(nibName: "BrandsNib", bundle: nil)
//        self.brandsCollection.register(nibCell, forCellWithReuseIdentifier: "brandsCell")
        
        brandsCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "brandsCell")

    }

}
