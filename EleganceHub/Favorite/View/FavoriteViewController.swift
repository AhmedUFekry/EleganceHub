//
//  FavoriteViewController.swift
//  EleganceHub
//
//  Created by Shimaa on 09/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var favoriteTableView: UITableView!
    var favoriteProducts: BehaviorRelay<[[String: Any]]> = BehaviorRelay(value: [])
        let disposeBag = DisposeBag()
            
        override func viewDidLoad() {
            super.viewDidLoad()

            favoriteTableView.register(UITableViewCell.self, forCellReuseIdentifier: "favcell")
            favoriteTableView.rx.setDelegate(self).disposed(by: disposeBag)
                
            if let userId = getLoggedInUserID() {
                print("User ID: \(userId)")
                let fetchedProducts = FavoriteCoreData.shared.fetchFavoritesByUserId(userId: userId) ?? []
                favoriteProducts.accept(fetchedProducts)
                print("Fetched Products: \(fetchedProducts)")
            } else {
                print("User ID not found.")
            }
                
            favoriteProducts.bind(to: favoriteTableView.rx.items(cellIdentifier: "favcell", cellType: UITableViewCell.self)) { row, product, cell in
                cell.textLabel?.text = product["title"] as? String
                cell.detailTextLabel?.text = product["price"] as? String
                    
                if let imageUrlString = product["image"] as? String, let imageUrl = URL(string: imageUrlString) {
                    self.loadImage(url: imageUrl) { image in
                        DispatchQueue.main.async {
                            cell.imageView?.image = image
                            cell.setNeedsLayout()
                        }
                    }
                }
            }.disposed(by: disposeBag)
                
            favoriteTableView.rx.itemDeleted.subscribe(onNext: { indexPath in
                let product = self.favoriteProducts.value[indexPath.row]
                if let productId = product["id"] as? Int, let customerId = self.getLoggedInUserID() {
                    self.showDeleteConfirmationAlert(productId: productId, customerId: customerId, indexPath: indexPath)
                }
            }).disposed(by: disposeBag)
            
            favoriteTableView.rx.modelSelected([String: Any].self).subscribe(onNext: { [weak self] product in
                self?.navigateToProductDetail(product: product)
            }).disposed(by: disposeBag)
        }
        
        func getLoggedInUserID() -> Int? {
            return UserDefaultsHelper.shared.getLoggedInUserID()
        }
                    
        func loadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, error == nil {
                    completion(UIImage(data: data))
                } else {
                    completion(nil)
                }
            }.resume()
        }
            
        func showDeleteConfirmationAlert(productId: Int, customerId: Int, indexPath: IndexPath) {
            let alert = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                self.deleteProduct(productId: productId, customerId: customerId, indexPath: indexPath)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
                
            present(alert, animated: true, completion: nil)
        }

        func deleteProduct(productId: Int, customerId: Int, indexPath: IndexPath) {
            FavoriteCoreData.shared.deleteFromCoreData(productId: productId, customerId: customerId)
            var updatedProducts = favoriteProducts.value
            updatedProducts.remove(at: indexPath.row)
            favoriteProducts.accept(updatedProducts)
        }
        
        func navigateToProductDetail(product: [String: Any]) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let productDetailVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController {
                productDetailVC.productId = product["id"] as? Int
                navigationController?.pushViewController(productDetailVC, animated: true)
            }
        }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}

extension FavoriteViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows: \(favoriteProducts.value.count)")
        return favoriteProducts.value.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Configuring cell for row \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "favcell", for: indexPath)
        let product = favoriteProducts.value[indexPath.row]
                    
        cell.textLabel?.text = product["title"] as? String
        cell.detailTextLabel?.text = product["price"] as? String
                    
        if let imageUrlString = product["image"] as? String, let imageUrl = URL(string: imageUrlString) {
            loadImage(url: imageUrl) { image in
                DispatchQueue.main.async {
                    cell.imageView?.image = image
                    cell.setNeedsLayout()
                }
            }
        }

        return cell
    }
        
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = favoriteProducts.value[indexPath.row]
            if let productId = product["id"] as? Int, let customerId = getLoggedInUserID() {
                showDeleteConfirmationAlert(productId: productId, customerId: customerId, indexPath: indexPath)
            }
        }
    }
}
