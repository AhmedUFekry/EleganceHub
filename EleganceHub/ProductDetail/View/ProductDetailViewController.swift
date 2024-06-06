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
        var availableColors: [String] = []

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

            // Initialize ViewModel with a network manager instance
            let networkManager = ProductDetailNetworkService()
            viewModel = ProductDetailViewModel(networkManager: networkManager)
            viewModel.bindingProduct = { [weak self] in
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            }
            
            viewModel.getProductDetails(productId: productId)
            
            viewModel.getAvailableSizesAndColors(productId: productId) { [weak self] sizes, colors in
                guard let self = self else { return }
                
                self.availableSizes = sizes
                self.availableColors = colors
                
                print("Available Sizes: \(sizes)")
                print("Available Colors: \(colors)")
                
                self.sizeCollectionView.reloadData()
                self.setupColorSelectorView()
            }
        }

        private func updateUI() {
            guard let product = viewModel.observableProduct else { return }
            ProductName.text = product.title
            productPrice.text = "$\(product.variants?.first?.price ?? "0.00")"
            ProductDescription.text = product.bodyHTML
            // Additional UI updates for images and other details can be done here
        }
        
        private func setupColorSelectorView() {
            let dynamicColors: [UIColor] = availableColors.map { color in
                switch color.lowercased() {
                case "black":
                    return .black
                case "green":
                    return .green
                case "red":
                    return .red
                case "blue":
                    return .blue
                case "brown":
                    return .brown
                case "purple":
                    return .purple
                case "orange":
                    return .orange
                case "white":
                    return .white
                case "yellow":
                    return .yellow

                default:
                    return .gray
                }
            }
            
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
            // Handle size selection if needed
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 50, height: 50)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
    }
