//
//  FavoriteCoreData.swift
//  EleganceHub
//
//  Created by Shimaa on 09/06/2024.
//

import Foundation
import CoreData
import UIKit

class FavoriteCoreData {
    static let shared = FavoriteCoreData()
    private init() {}
    
    var favoriteProducts: [[String: Any]] = []
    
    func saveToCoreData(_ dataArray: [[String: Any]], completion: @escaping (Bool, Error?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false, NSError(domain: "AppDelegateNotFound", code: -1, userInfo: nil))
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for productData in dataArray {
            guard let id = productData["id"] as? Int,
                  let customer_id = productData["customer_id"] as? Int,
                  let variant_id = productData["variant_id"] as? Int,
                  let title = productData["title"] as? String,
                  let price = productData["price"] as? String,
                  let image = productData["image"] as? String else {
                continue
            }
            
            let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            
            do {
                let existingProducts = try managedContext.fetch(fetchRequest)
                
                if existingProducts.isEmpty {
                    let newProduct = FavoriteProduct(context: managedContext)
                    newProduct.id = Int64(id)
                    newProduct.customer_id = Int64(customer_id)
                    newProduct.variant_id = Int64(variant_id)
                    newProduct.title = title
                    newProduct.price = price
                    newProduct.image = image
                    
                    try managedContext.save()
                    print("Product with id \(id) saved to Core Data.")
                } else {
                    print("Product with id \(id) already exists in Core Data. Skipping save.")
                }
            } catch {
                completion(false, error)
                continue
            }
        }
        
        completion(true, nil)
    }
    
    func fetchDataFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            favoriteProducts = results.map { product in
                [
                    "id": Int(product.id),
                    "customer_id": Int(product.customer_id),
                    "variant_id": Int(product.variant_id),
                    "title": product.title ?? "",
                    "price": product.price ?? "",
                    "image": product.image ?? ""
                ]
            }
            
        } catch {
            print("Error fetching data from Core Data: \(error.localizedDescription)")
        }
    }
    
    func deleteFromCoreData(id: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let existingLeagues = try managedContext.fetch(fetchRequest)
            for league in existingLeagues {
                managedContext.delete(league)
            }
            try managedContext.save()
            print("product of  \(id) deleted from Core Data.")
        } catch {
            print("Error deleting league from Core Data: \(error.localizedDescription)")
        }
    }

//MARK: - need modification...
    func isProductInFavorites(productKey: Int, productName: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productName == %@ AND productKey == %@", productName, NSNumber(value: productKey))
        
        do {
            let existingLeagues = try managedContext.fetch(fetchRequest)
            return !existingLeagues.isEmpty
        } catch {
            print("Error checking product in favorites: \(error.localizedDescription)")
            return false
        }
    }

}
