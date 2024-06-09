//
//  DatabaseService.swift
//  EleganceHub
//
//  Created by AYA on 08/06/2024.
//

import Foundation
import UIKit
import RxSwift

class DatabaseService{
    private let defaults = UserDefaults.standard
    
    func saveImage(_ image: UIImage, forKey key: String) {
        if let imageData = image.pngData() {
            defaults.set(imageData, forKey: key)
        }
    }

    func getImage(forKey key: String) -> UIImage? {
        if let imageData = defaults.data(forKey: key) {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    
}
