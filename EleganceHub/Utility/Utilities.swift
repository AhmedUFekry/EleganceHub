//
//  Utilities.swift
//  EleganceHub
//
//  Created by Shimaa on 02/06/2024.
//

import Foundation
import UIKit

class Utilities {
    
    static func splitName(text: String, delimiter: String) -> String {
        let substrings = text.components(separatedBy: delimiter)
        return substrings.last ?? text
    }
    
    static func formatRating(ratingString: String?) -> String {
        if let ratingString = ratingString, let rating = Double(ratingString) {
            return String(format: "%.1f ★", rating)
        } else {
            return "No Rating"
        }
    }
    
}
extension UIView {
    func applyShadow(color: UIColor = .black,
                     opacity: Float = 0.5,
                     offset: CGSize = CGSize(width: 0, height: 2),
                     radius: CGFloat = 4,
                     cornerRadius: CGFloat = 10) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false

    }
}
