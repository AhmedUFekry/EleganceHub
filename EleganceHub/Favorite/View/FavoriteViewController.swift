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
    
    // UI elements for empty state
        private var emptyStateImageView: UIImageView!
        private var emptyStateLabel: UILabel!
    private var emptyStateSubLabel: UILabel!
            
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        loadFavoriteProducts()
        bindTableView()
        setupTableViewInteractions()
        
        setupEmptyStateUI()
                updateEmptyStateVisibility()
    }
    
    private func setupTableView() {
        favoriteTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        favoriteTableView.rx.setDelegate(self).disposed(by: disposeBag)
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

    private func bindTableView() {
        favoriteProducts.bind(to: favoriteTableView.rx.items(cellIdentifier: "CartTableViewCell", cellType: CartTableViewCell.self)) { [weak self] row, product, cell in
            self?.configureCell(cell, with: product, at: row)
        }.disposed(by: disposeBag)
    }

    private func setupTableViewInteractions() {
        favoriteTableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            guard let product = self?.favoriteProducts.value[indexPath.row],
                  let productId = product["id"] as? Int,
                  let customerId = self?.getLoggedInUserID() else {
                return
            }
            self?.showDeleteConfirmationAlert(productId: productId, customerId: customerId, indexPath: indexPath)
        }).disposed(by: disposeBag)
        
        favoriteTableView.rx.modelSelected([String: Any].self).subscribe(onNext: { [weak self] product in
            self?.navigateToProductDetail(product: product)
        }).disposed(by: disposeBag)
    }

    private func configureCell(_ cell: CartTableViewCell, with product: [String: Any], at row: Int) {
            if let title = product["title"] as? String,
               let price = product["price"] as? String,
               let imageUrlString = product["image"] as? String,
               let imageUrl = URL(string: imageUrlString) {
                cell.productNameLabel.text = title
                cell.productPriceLabel.text = price
                cell.productImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "AppIcon"))
            }
            cell.productVarintLabel.text = product["variant"] as? String
            
            // Hide quantity and buttons in favorite list
            cell.decreaseQuantityBtn.isHidden = true
            cell.IncreaseQuantityBtn.isHidden = true
            cell.productQuantityLabel.isHidden = true
            
            // Add "Add to Cart" button
            let addToCartBtn = UIButton(type: .system)
            addToCartBtn.setTitle("Add To Cart", for: .normal)
            addToCartBtn.backgroundColor = .black
            addToCartBtn.setTitleColor(.white, for: .normal)
            addToCartBtn.layer.cornerRadius = 10
            
            cell.contentView.addSubview(addToCartBtn)
            
            addToCartBtn.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                addToCartBtn.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 220),
                addToCartBtn.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                addToCartBtn.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -18),
                addToCartBtn.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            addToCartBtn.tag = row
            addToCartBtn.addTarget(self, action: #selector(addToCartButtonTapped(_:)), for: .touchUpInside)
        }
    func getLoggedInUserID() -> Int? {
        return UserDefaultsHelper.shared.getLoggedInUserID()
    }
    
    @objc func addToCartButtonTapped(_ sender: UIButton) {
        let productIndex = sender.tag
        let product = favoriteProducts.value[productIndex]

        print("Add to Cart button tapped for product: \(product)")
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
        
        updateEmptyStateVisibility()
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
            let count = favoriteProducts.value.count
            
            // Toggle empty state visibility based on product count
            if count == 0 {
                favoriteTableView.backgroundView = emptyStateImageView
            } else {
                favoriteTableView.backgroundView = nil
            }
            
            return count
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Configuring cell for row \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        let product = favoriteProducts.value[indexPath.row]
                    
        if let title = product["title"] as? String,
           let price = product["price"] as? String,
           let imageUrlString = product["image"] as? String,
           let imageUrl = URL(string: imageUrlString) {
            cell.productNameLabel.text = title
            cell.productPriceLabel.text = price
            cell.productImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "AppIcon"))
        }
        cell.productQuantityLabel.text = "1"
        cell.productVarintLabel.text = product["variant"] as? String
        
        cell.decreaseQuantityBtn.isHidden = true
        cell.IncreaseQuantityBtn.isHidden = true
        cell.productQuantityLabel.isHidden = true
        
        let addToCartBtn = UIButton(type: .system)
            addToCartBtn.setTitle("Add To Cart", for: .normal)
            addToCartBtn.backgroundColor = .black
            addToCartBtn.setTitleColor(.white, for: .normal)
            addToCartBtn.layer.cornerRadius = 10

            cell.contentView.addSubview(addToCartBtn)

            addToCartBtn.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                addToCartBtn.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 220),
                addToCartBtn.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                addToCartBtn.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -18),
                addToCartBtn.heightAnchor.constraint(equalToConstant: 40)
            ])

            addToCartBtn.tag = indexPath.row
            addToCartBtn.addTarget(self, action: #selector(addToCartButtonTapped(_:)), for: .touchUpInside)

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
    
    // MARK: - Empty State Handling
        
    private func setupEmptyStateUI() {
        emptyStateImageView = UIImageView(image: UIImage(named: "emptybox"))
        emptyStateImageView.contentMode = .scaleAspectFit

        emptyStateLabel = UILabel()
        emptyStateLabel.text = "Your Wishlist is empty!"
        emptyStateLabel.font = UIFont(name: "Palatino", size: 20)
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.textColor = .black

        emptyStateSubLabel = UILabel()
        emptyStateSubLabel.text = "Tab heart button to start saving your favorite items."
        emptyStateLabel.font = UIFont(name: "Palatino", size: 16)
        emptyStateSubLabel.textAlignment = .center
        emptyStateSubLabel.numberOfLines = 0
        emptyStateSubLabel.textColor = .gray
        
        let stackView = UIStackView(arrangedSubviews: [emptyStateImageView, emptyStateLabel,emptyStateSubLabel])
        stackView.axis = .vertical
        stackView.spacing = 16.0
        stackView.alignment = .center
        
        favoriteTableView.backgroundView = stackView
        

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: favoriteTableView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: favoriteTableView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: favoriteTableView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: favoriteTableView.trailingAnchor, constant: -16)
        ])
    }

        
        private func updateEmptyStateVisibility() {
            favoriteTableView.backgroundView?.isHidden = !favoriteProducts.value.isEmpty
        }
    }

