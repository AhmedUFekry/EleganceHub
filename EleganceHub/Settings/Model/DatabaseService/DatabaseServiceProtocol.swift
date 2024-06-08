//
//  DatabaseServiceProtocol.swift
//  EleganceHub
//
//  Created by AYA on 08/06/2024.
//

import Foundation
import UIKit
import RxSwift


protocol DatabaseServiceProtocol{
    func saveImage(_ image: UIImage, forKey key: String)
    func getImage(forKey key: String) -> UIImage?
}
