//
//  ProductDetailViewController.swift
//  EleganceHub
//
//  Created by Shimaa on 03/06/2024.
//

import UIKit

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var colorSelectorContainer: UIView!
    
    @IBOutlet weak var imageSlider: UIPageControl!
    //@IBOutlet weak var ProductImagesCollection: UICollectionView!
    
    @IBOutlet weak var ProductName: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var ProductDescription: UILabel!
    
    
    var colorSelectorView: ColorSelectorView!
    //let sizes = ["S", "M", "L", "XL", "XXL"]
    var availableSizes: [String] = []

        var productId: Int = 0 // This should be set before the view loads
            var viewModel: ProductDetailViewModel!

            override func viewDidLoad() {
                super.viewDidLoad()

                sizeCollectionView.delegate = self
                sizeCollectionView.dataSource = self

                // Register the custom cell
                sizeCollectionView.register(SizeOptionCell.self, forCellWithReuseIdentifier: "SizeOptionCell")
                
                // Configure the collection view layout for horizontal scrolling
                if let layout = sizeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal
                }

                // Setup color selector view
                let dynamicColors: [UIColor] = [.black, .green, .orange] // This can be dynamic
                colorSelectorView = ColorSelectorView(colors: dynamicColors)
                colorSelectorView.translatesAutoresizingMaskIntoConstraints = false
                colorSelectorContainer.addSubview(colorSelectorView)

                // Setup constraints for color selector view
                NSLayoutConstraint.activate([
                    colorSelectorView.leadingAnchor.constraint(equalTo: colorSelectorContainer.leadingAnchor),
                    colorSelectorView.trailingAnchor.constraint(equalTo: colorSelectorContainer.trailingAnchor),
                    colorSelectorView.topAnchor.constraint(equalTo: colorSelectorContainer.topAnchor),
                    colorSelectorView.bottomAnchor.constraint(equalTo: colorSelectorContainer.bottomAnchor)
                ])

                // Initialize ViewModel with a network manager instance
                let networkManager = ProductDetailNetworkService()
                viewModel = ProductDetailViewModel(networkManager: networkManager)
                viewModel.bindingProduct = { [weak self] in
                    DispatchQueue.main.async {
                        self?.updateUI()
                    }
                }
                viewModel.getProductDetails(productId: productId)
                // Fetch available sizes
                        viewModel.getAvailableSizes(productId: productId) { [weak self] sizes in
                            self?.availableSizes = sizes
                            self?.sizeCollectionView.reloadData()
                        }
            }

            private func updateUI() {
                guard let product = viewModel.observableProduct else { return }
                ProductName.text = product.title
                productPrice.text = "$\(product.variants?.first?.price ?? "0.00")"
                ProductDescription.text = product.bodyHTML
                // Additional UI updates for images and other details can be done here
            }
        }

extension ProductDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableSizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeOptionCell", for: indexPath) as! SizeOptionCell
        cell.sizeLabel.text = availableSizes[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedSize = availableSizes[indexPath.row]
//        viewModel.getAvailableColors(forSize: selectedSize) { [weak self] colors in
//            guard let colors = colors else { return }
//            self?.setupColorSelectorView(with: colors)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
