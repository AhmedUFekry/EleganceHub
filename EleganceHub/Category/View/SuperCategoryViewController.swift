//
//  SuperCategoryViewController.swift
//  EleganceHub
//
//  Created by raneem on 01/06/2024.
//

import UIKit
import Kingfisher
import JJFloatingActionButton

class SuperCategoryViewController: UIViewController {
    
    @IBOutlet weak var segmentCategory: UISegmentedControl!
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    let categoryViewModel = CategoryViewModel()
    var categoryProductList : [Product]?
    var filteredList : [Product]?
    var isFiltered : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNib()
        categoryViewModel.bindResultToViewController = { [weak self] in
            guard let self = self else {return}
            self.categoryProductList = self.categoryViewModel.categoryResult
            self.renderView()
        }
        displayFloatingButton()
    }
    
    
    func loadNib(){
        let categoryNibCell = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        categoryCollection.register(categoryNibCell, forCellWithReuseIdentifier: "CategoryCell")
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
    
    func displayFloatingButton(){
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
            self.categoryCollection.reloadData()
            
        }

        actionButton.addItem(title: "T-Shirts", image: UIImage(named: "tshirt")?.withRenderingMode(.alwaysTemplate)) { item in
            self.isFiltered = true
            self.filteredList = self.categoryViewModel.filterCategory(filterType: "T-SHIRTS")
            self.categoryCollection.reloadData()
        }

        actionButton.addItem(title: "Accessories", image: UIImage(named: "Accsesory")?.withRenderingMode(.alwaysTemplate)) { item in
            self.isFiltered = true
            self.filteredList = self.categoryViewModel.filterCategory(filterType: "ACCESSORIES")
            self.categoryCollection.reloadData()
        }
        actionButton.display(inViewController: self)
    }
    
    
}
extension SuperCategoryViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltered{
            return filteredList?.count ?? 0
        }else{
            return categoryProductList?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        let category = categoryProductList?[indexPath.row]
        
        categoryCell.categoryTitle?.text = category?.title
        KF.url(URL(string: category?.image?.src ?? "https://cdn.shopify.com/s/files/1/0880/0426/4211/collections/a340ce89e0298e52c438ae79591e3284.jpg?v=1716276581"))
            .set(to: categoryCell.categoryImage)
        categoryCell.categoryType?.text = category?.productType
        categoryCell.categoryPrice?.text = category?.variants?[0].price


        
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


