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
    
    @IBOutlet weak var categorySearchBar: UISearchBar!
    @IBOutlet weak var segmentCategory: UISegmentedControl!
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    let categoryViewModel = CategoryViewModel()
    var categoryProductList: [Product]?
    var filteredList: [Product]?
    var searchList: [Product]?
    
    var isFiltered: Bool = false
    var isSearching: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNib()
        categorySearchBar.delegate = self
        categoryViewModel.bindResultToViewController = { [weak self] in
            guard let self = self else { return }
            self.categoryProductList = self.categoryViewModel.categoryResult
            self.renderView()
        }
        displayFloatingButton()
        categoryViewModel.getCategoryProducts(category: .Women)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.renderView()
    }
    
    func loadNib() {
        let categoryNibCell = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        categoryCollection.register(categoryNibCell, forCellWithReuseIdentifier: "CategoryCell")
    }
    
    func renderView() {
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
}



