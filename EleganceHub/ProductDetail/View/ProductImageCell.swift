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

extension UIImageView {
    func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to load image from URL: \(url), Error: \(String(describing: error))")
                return
            }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
        task.resume()
    }
}
