//
//  ProductImageCell.swift
//  EleganceHub
//
//  Created by Shimaa on 07/06/2024.
//

import UIKit

class ProductImageCell: UICollectionViewCell {
    var productImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupImageView()
    }
    
    private func setupImageView() {
        productImageView = UIImageView(frame: contentView.bounds)
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        contentView.addSubview(productImageView)
    }
}

// UIImageView extension to load image from URL


extension UIImageView {
    func loadImage(from url: URL) {
        // Create a data task to load the image
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Ensure there is no error and data exists
            guard let data = data, error == nil else {
                print("Failed to load image from URL: \(url), Error: \(String(describing: error))")
                return
            }
            
            // Create the image from data
            if let image = UIImage(data: data) {
                // Update the image view on the main thread
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
        // Start the task
        task.resume()
    }
}
