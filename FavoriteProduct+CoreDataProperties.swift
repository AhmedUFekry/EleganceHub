//
//  FavoriteProduct+CoreDataProperties.swift
//  
//
//  Created by Shimaa on 09/06/2024.
//
//

import Foundation
import CoreData


extension FavoriteProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteProduct> {
        return NSFetchRequest<FavoriteProduct>(entityName: "FavoriteProduct")
    }

    @NSManaged public var image: String?
    @NSManaged public var price: String?
    @NSManaged public var title: String?
    @NSManaged public var variant_id: Int64
    @NSManaged public var customer_id: Int64
    @NSManaged public var id: Int64

}
