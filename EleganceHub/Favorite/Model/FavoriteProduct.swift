//
//  FavoriteProduct.swift
//  EleganceHub
//
//  Created by Shimaa on 09/06/2024.
//

import Foundation
import CoreData

class FavoriteProducts : Codable{
    var id: Int?
    var customer_id: Int?
    var variant_id: Int?
    var title: String?
    var price: String?
    var image: String?
    

}

//struct FavoriteResponse: Decodable {
//    let success: Int?
//    let result: [FavoriteProducts]?
//
//}


