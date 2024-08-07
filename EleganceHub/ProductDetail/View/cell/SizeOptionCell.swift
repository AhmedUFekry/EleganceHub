//
//  SizeOptionCell.swift
//  EleganceHub
//
//  Created by Shimaa on 03/06/2024.
//

import UIKit

class SizeOptionCell: UICollectionViewCell {
    let isDarkMode = UserDefaultsHelper.shared.isDarkMode()
    let sizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor(named: "btnColor") ?? .black : .clear
            
            if isDarkMode{
                sizeLabel.textColor = isSelected ? .black : .white
               
            }else{
                sizeLabel.textColor = isSelected ? .white : .black
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    
    private func setupViews() {
        contentView.addSubview(sizeLabel)
        contentView.layer.cornerRadius = contentView.frame.size.height / 2
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(named: "btnColor")?.cgColor ?? UIColor.black.cgColor
        contentView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            sizeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            sizeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
