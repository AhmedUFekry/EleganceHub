//
//  ColorSelectorView.swift
//  EleganceHub
//
//  Created by Shimaa on 06/06/2024.
//

import UIKit

class ColorSelectorView: UIView {
    
    private var colors: [UIColor] = []
    private var buttons: [UIButton] = []
    private var selectedIndicator: UIView!
    var selectedColor: UIColor?

    init(colors: [UIColor]) {
        self.colors = colors
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4

        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()

        for (index, color) in colors.enumerated() {
            let button = UIButton(type: .system)
            button.backgroundColor = color
            button.layer.cornerRadius = 15
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.clear.cgColor
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = index
            button.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
            addSubview(button)
            buttons.append(button)
        }

        for (index, button) in buttons.enumerated() {
            button.widthAnchor.constraint(equalToConstant: 30).isActive = true
            button.heightAnchor.constraint(equalToConstant: 30).isActive = true
            if index == 0 {
                button.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
            } else {
                button.topAnchor.constraint(equalTo: buttons[index - 1].bottomAnchor, constant: 10).isActive = true
            }
        button.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
        selectedIndicator = UIView()
        selectedIndicator.backgroundColor = .clear
        selectedIndicator.layer.cornerRadius = 15
        selectedIndicator.layer.borderWidth = 2
        selectedIndicator.layer.borderColor = UIColor.black.cgColor
        selectedIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectedIndicator)
        bringSubviewToFront(selectedIndicator)
        
        if let firstButton = buttons.first {
            updateSelection(to: firstButton)
        }
    }

    @objc private func colorSelected(_ sender: UIButton) {
        updateSelection(to: sender)
    }

    private func updateSelection(to button: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.selectedIndicator.frame = button.frame
        }
        selectedColor = button.backgroundColor
    }
}
