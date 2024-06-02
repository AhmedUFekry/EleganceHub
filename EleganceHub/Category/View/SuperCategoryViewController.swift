//
//  SuperCategoryViewController.swift
//  EleganceHub
//
//  Created by raneem on 01/06/2024.
//

import UIKit
import Kingfisher

class SuperCategoryViewController: UIViewController {
    
    @IBOutlet weak var segmentCategory: UISegmentedControl!
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    let categoryViewModel = CategoryViewModel()
    var categoryProductList : [Product]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let categoryNibCell = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        categoryCollection.register(categoryNibCell, forCellWithReuseIdentifier: "CategoryCell")
        
        categoryViewModel.bindResultToViewController = { [weak self] in
            guard let self = self else {return}
            self.categoryProductList = self.categoryViewModel.categoryResult
            self.renderView()
        }
    }
    func renderView(){
        DispatchQueue.main.async {
            self.categoryCollection.reloadData()
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
    
    

}
extension SuperCategoryViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryProductList?.count ?? 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        let category = categoryProductList?[indexPath.row]
        
        categoryCell.categoryTitle?.text = category?.title
        KF.url(URL(string: category?.image?.src ?? "https://cdn.shopify.com/s/files/1/0880/0426/4211/collections/a340ce89e0298e52c438ae79591e3284.jpg?v=1716276581"))
            .set(to: categoryCell.categoryImage)
        categoryCell.categoryType?.text = category?.productType
        categoryCell.categoryPrice?.text = (category?.variants?[0].price)! + "$"


        
        return categoryCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 0
        let collectionViewSize = collectionView.frame.size.width - padding
        let width = collectionViewSize / 2
        let height = width
        return CGSize(width: width, height: height)
    }
    
}
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


