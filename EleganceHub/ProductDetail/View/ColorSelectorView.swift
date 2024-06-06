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
            // Add shadow to the view
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.3
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowRadius = 4

            // Remove any existing buttons if re-setup is needed
            buttons.forEach { $0.removeFromSuperview() }
            buttons.removeAll()

            // Setup buttons for each color
            for (index, color) in colors.enumerated() {
                let button = UIButton(type: .system)
                button.backgroundColor = color
                button.layer.cornerRadius = 15 // Adjust the corner radius for smaller size
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.clear.cgColor
                button.translatesAutoresizingMaskIntoConstraints = false
                button.tag = index
                button.addTarget(self, action: #selector(colorSelected(_:)), for: .touchUpInside)
                addSubview(button)
                buttons.append(button)
            }

            // Setup constraints
            for (index, button) in buttons.enumerated() {
                button.widthAnchor.constraint(equalToConstant: 30).isActive = true // Adjusted button width
                button.heightAnchor.constraint(equalToConstant: 30).isActive = true // Adjusted button height
                if index == 0 {
                    button.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
                } else {
                    button.topAnchor.constraint(equalTo: buttons[index - 1].bottomAnchor, constant: 10).isActive = true
                }
                button.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            }

            // Setup selected indicator
            selectedIndicator = UIView()
            selectedIndicator.backgroundColor = .clear
            selectedIndicator.layer.cornerRadius = 15 // Adjust the corner radius for smaller size
            selectedIndicator.layer.borderWidth = 2
            selectedIndicator.layer.borderColor = UIColor.black.cgColor
            selectedIndicator.translatesAutoresizingMaskIntoConstraints = false
            addSubview(selectedIndicator)
            bringSubviewToFront(selectedIndicator)

            // Initial selection
            if let firstButton = buttons.first {
                updateSelection(to: firstButton)
            }
        }

        @objc private func colorSelected(_ sender: UIButton) {
            updateSelection(to: sender)
        }

        private func updateSelection(to button: UIButton) {
            // Move the selected indicator to the selected button
            UIView.animate(withDuration: 0.3) {
                self.selectedIndicator.frame = button.frame
            }
            selectedColor = button.backgroundColor
        }
    }
