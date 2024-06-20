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
            guard let productId = productData["id"] as? Int,
                  let variant_id = productData["variant_id"] as? Int,
                  let title = productData["title"] as? String,
                  let price = productData["price"] as? String,
                  let image = productData["image"] as? String,
                  let inventory_quantity = productData["inventory_quantity"] as? Int,
                  let product_type = productData["product_type"] as? String else {
                continue
            }
            
            print("Data to be saved: \(productData)")
            
            let idNumber = NSDecimalNumber(value: productId)
            
            let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", idNumber)
            
            do {
                let existingProducts = try managedContext.fetch(fetchRequest)
                
                if existingProducts.isEmpty {
                    let newProduct = FavoriteProduct(context: managedContext)
                    newProduct.id = idNumber
                    newProduct.customer_id = NSDecimalNumber(value: UserDefaultsHelper.shared.getLoggedInUserID() ?? 0)
                    newProduct.variant_id = NSDecimalNumber(value: variant_id)
                    newProduct.title = title
                    newProduct.price = price
                    newProduct.image = image
                    newProduct.inventory_quantity = NSDecimalNumber(value: inventory_quantity)
                    newProduct.product_type = product_type
                    
                    try managedContext.save()
                    print("Product with id \(productId) saved to Core Data.")
                } else {
                    print("Product with id \(productId) already exists in Core Data. Skipping save.")
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
        
        print("Customer ID Number: \(userIdNumber)")
        
        let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "customer_id == %@", userIdNumber)
        
        print("Fetch request: \(fetchRequest)")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            print("Fetched products count: \(results.count)")
            let favoriteProducts = results.map { product in
                // Map to dictionary format
                return [
                    "id": Int(truncating: product.id ?? 0),
                    "customer_id": Int(truncating: product.customer_id ?? 0),
                    "variant_id": Int(truncating: product.variant_id ?? 0),
                    "title": product.title ?? "",
                    "price": product.price ?? "", // Convert NSDecimalNumber to String
                    "image": product.image ?? "",
                    "inventory_quantity": Int(truncating: product.inventory_quantity ?? 0),
                    "product_type": product.product_type ?? ""
                ]
            }
            print("Fetched Products: \(favoriteProducts)")
            return favoriteProducts
        } catch {
            print("Error fetching data from Core Data: \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteFromCoreData(productId: Int, customerId: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let idNumber = NSDecimalNumber(value: productId)
        let customerIdNumber = NSDecimalNumber(value: customerId)
        
        let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND customer_id == %@", idNumber, customerIdNumber)
        
        do {
            let existingProducts = try managedContext.fetch(fetchRequest)
            for product in existingProducts {
                managedContext.delete(product)
            }
            try managedContext.save()
            print("Product with id \(productId) and customer_id \(customerId) deleted from Core Data.")
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
