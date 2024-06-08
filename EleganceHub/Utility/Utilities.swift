//
//  Utilities.swift
//  EleganceHub
//
//  Created by Shimaa on 02/06/2024.
//

import Foundation

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
