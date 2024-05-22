//
//  TabBarCorners.swift
//  EleganceHub
//
//  Created by raneem on 23/05/2024.
//

import UIKit

class TabBarCorners: UITabBar {
    
    private var shapeLayer: CALayer?

        override func draw(_ rect: CGRect) {
            addShape()
        }

        private func addShape() {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = createPath()
            shapeLayer.strokeColor = UIColor.clear.cgColor
            shapeLayer.fillColor = UIColor.white.cgColor
            shapeLayer.lineWidth = 1.0
            
            shapeLayer.shadowColor = UIColor.black.cgColor
            shapeLayer.shadowOffset = CGSize(width: 0, height: -3)
            shapeLayer.shadowOpacity = 0.3
            shapeLayer.shadowRadius = 10
            
            if let oldShapeLayer = self.shapeLayer {
                self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
            } else {
                self.layer.insertSublayer(shapeLayer, at: 0)
            }

            self.shapeLayer = shapeLayer
        }

        private func createPath() -> CGPath {
            let path = UIBezierPath(
                roundedRect: CGRect(
                    x: self.bounds.minX + 0,
                    y: self.bounds.minY - 0,
                    width: self.bounds.width - 0,
                    height: self.bounds.height + 0),
                cornerRadius: 20)

            return path.cgPath
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            self.isTranslucent = true
            self.layer.cornerRadius = 20
            self.clipsToBounds = false  
        }
}
