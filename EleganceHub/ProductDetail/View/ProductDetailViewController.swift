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
    @IBOutlet weak var ProductImagesCollection: UICollectionView!
    
    @IBOutlet weak var ProductName: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var ProductDescription: UILabel!
    
    
    var colorSelectorView: ColorSelectorView!
        var availableSizes: [String] = []
        var availableColors: [String] = []
        var sizeColorMap: [String: [String]] = [:]
        var selectedSize: String?
        var productId: Int = 9425664999699  // Static product Id
        var viewModel: ProductDetailViewModel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            sizeCollectionView.delegate = self
            sizeCollectionView.dataSource = self
            sizeCollectionView.register(SizeOptionCell.self, forCellWithReuseIdentifier: "SizeOptionCell")
            
            ProductImagesCollection.delegate = self
            ProductImagesCollection.dataSource = self
            ProductImagesCollection.register(ProductImageCell.self, forCellWithReuseIdentifier: "ProductImageCell")
            
            if let layout = sizeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
            
            let networkManager = ProductDetailNetworkService()
            viewModel = ProductDetailViewModel(networkManager: networkManager)
            viewModel.bindingProduct = { [weak self] in
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            }
            
            viewModel.getProductDetails(productId: productId)
            
            viewModel.getAvailableVarients(productId: productId) { [weak self] sizeColorMap, colors in
                guard let self = self else { return }
                
                self.sizeColorMap = sizeColorMap
                self.availableColors = colors
                self.availableSizes = Array(sizeColorMap.keys)
                
                print("Available Sizes: \(self.availableSizes)")
                print("Available Colors: \(colors)")
                
                self.sizeCollectionView.reloadData()
                self.setupColorSelectorView()
            }
        }
        
        private func updateUI() {
            guard let product = viewModel.observableProduct else {
                print("Observable product is nil.")
                return
            }
            
            print("Product Title: \(product.title ?? "No title")")
            print("Product Price: \(product.variants?.first?.price ?? "No price")")
            print("Product Description: \(product.bodyHTML ?? "No description")")
            
            ProductName.text = product.title ?? "No title"
            productPrice.text = "$\(product.variants?.first?.price ?? "0.00")"
            ProductDescription.text = product.bodyHTML ?? "No description"
            
            ProductImagesCollection.reloadData()
            imageSlider.numberOfPages = product.images?.count ?? 0
        }
        
        private func setupColorSelectorView(filteredColors: [String]? = nil) {
            colorSelectorView?.removeFromSuperview()

            if let filteredColors = filteredColors {
                let dynamicColors: [UIColor] = filteredColors.map { color in
                    return colorToUIColor(color)
                }

                colorSelectorView = ColorSelectorView(colors: dynamicColors)
            } else {
                let dynamicColors: [UIColor] = availableColors.map { color in
                    return colorToUIColor(color)
                }

                colorSelectorView = ColorSelectorView(colors: dynamicColors)
            }

            colorSelectorView.translatesAutoresizingMaskIntoConstraints = false
            colorSelectorContainer.addSubview(colorSelectorView)

            NSLayoutConstraint.activate([
                colorSelectorView.leadingAnchor.constraint(equalTo: colorSelectorContainer.leadingAnchor),
                colorSelectorView.trailingAnchor.constraint(equalTo: colorSelectorContainer.trailingAnchor),
                colorSelectorView.topAnchor.constraint(equalTo: colorSelectorContainer.topAnchor),
                colorSelectorView.bottomAnchor.constraint(equalTo: colorSelectorContainer.bottomAnchor)
            ])
        }

        private func colorToUIColor(_ color: String) -> UIColor {
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
    
   
    @IBAction func addToFavorite(_ sender: Any) {
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToCart(_ sender: Any) {
        
    }
    
    }

    extension ProductDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == sizeCollectionView {
                return availableSizes.count
            } else {
                return viewModel.observableProduct?.images?.count ?? 0
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == sizeCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeOptionCell", for: indexPath) as! SizeOptionCell
                cell.sizeLabel.text = availableSizes[indexPath.row]
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath) as! ProductImageCell
                if let imageUrlString = viewModel.observableProduct?.images?[indexPath.row].src, let imageUrl = URL(string: imageUrlString) {
                    cell.productImageView.loadImage(from: imageUrl)
                }
                return cell
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if collectionView == sizeCollectionView {
                selectedSize = availableSizes[indexPath.row]
                if let selectedSize = selectedSize, let colorsForSelectedSize = sizeColorMap[selectedSize] {
                    setupColorSelectorView(filteredColors: colorsForSelectedSize)
                } else {
                    setupColorSelectorView()
                }
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if collectionView == sizeCollectionView {
                return CGSize(width: 50, height: 50)
            } else {
                return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            if scrollView == ProductImagesCollection {
                let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
                imageSlider.currentPage = page
            }
        }
    }
