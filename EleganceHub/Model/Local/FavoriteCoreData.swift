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
    
        guard let userId = UserDefaultsHelper.shared.getLoggedInUserID() else {
            completion(false, NSError(domain: "UserIDNotFound", code: -1, userInfo: nil))
            return
        }
        
        let customerIdNumber = NSDecimalNumber(value: userId)
        
        for productData in dataArray {
            guard let id = productData["id"] as? Int,
                  let variant_id = productData["variant_id"] as? Int,
                  let title = productData["title"] as? String,
                  let price = productData["price"] as? String,
                  let image = productData["image"] as? String else {
                continue
            }
            
            print("Data to be saved: \(productData)")
            
            let idNumber = NSDecimalNumber(value: id)
            
            let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@ AND customer_id == %@", idNumber, customerIdNumber)
                        
            do {
                let existingProducts = try managedContext.fetch(fetchRequest)
                
                if existingProducts.isEmpty {
                    let newProduct = FavoriteProduct(context: managedContext)
                    newProduct.id = idNumber
                    newProduct.customer_id = customerIdNumber
                    newProduct.variant_id = NSDecimalNumber(value: variant_id)
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

    func fetchFavoritesByUserId(userId: Int) -> [[String: Any]]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userIdNumber = NSDecimalNumber(value: userId)
        
        let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "customer_id == %@", userIdNumber)
        
        print("Fetch request: \(fetchRequest)")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            let favoriteProducts = results.map { product in
                let favoriteProductDict: [String: Any] = [
                    "id": Int(truncating: product.id ?? 0),
                    "customer_id": Int(truncating: product.customer_id ?? 0),
                    "variant_id": Int(truncating: product.variant_id ?? 0),
                    "title": product.title ?? "",
                    "price": product.price ?? "",
                    "image": product.image ?? ""
                ]
                print("Fetched product: \(favoriteProductDict)")
                return favoriteProductDict
            }
            print("Fetched products count: \(favoriteProducts.count)")
            return favoriteProducts
        } catch {
            print("Error fetching data from Core Data: \(error.localizedDescription)")
            return nil
        }
    }

    func deleteFromCoreData(id: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let idNumber = NSDecimalNumber(value: id)
        
        let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", idNumber)
        
        do {
            let existingProducts = try managedContext.fetch(fetchRequest)
            for product in existingProducts {
                managedContext.delete(product)
            }
            try managedContext.save()
            print("Product with id \(id) deleted from Core Data.")
        } catch {
            print("Error deleting product from Core Data: \(error.localizedDescription)")
        }
    }

    func isProductInFavorites(productId: Int, productName: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let productIdNumber = NSDecimalNumber(value: productId)
        
        let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@ AND id == %@", productName, productIdNumber)
        
        do {
            let existingProducts = try managedContext.fetch(fetchRequest)
            return !existingProducts.isEmpty
        } catch {
            print("Error checking product in favorites: \(error.localizedDescription)")
            return false
        }
    }
}
