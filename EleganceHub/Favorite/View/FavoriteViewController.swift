//
//  FavoriteViewController.swift
//  EleganceHub
//
//  Created by Shimaa on 09/06/2024.
//

import UIKit

class FavoriteViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var favoriteTableView: UITableView!
    var favoriteProducts: [[String: Any]] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
        favoriteTableView.register(UITableViewCell.self, forCellReuseIdentifier: "favcell")

        if let userId = getLoggedInUserID() {
            print("User ID: \(userId)")
            favoriteProducts = FavoriteCoreData.shared.fetchFavoritesByUserId(userId: userId) ?? []
            print("Fetched Products: \(favoriteProducts)")
        } else {
            print("User ID not found.")
        }
        favoriteTableView.reloadData()
    }
            
    func getLoggedInUserID() -> Int? {
        return UserDefaultsHelper.shared.getLoggedInUserID()
    }
            
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows: \(favoriteProducts.count)")
        return favoriteProducts.count
    }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Configuring cell for row \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "favcell", for: indexPath)
        let product = favoriteProducts[indexPath.row]
                
        cell.textLabel?.text = product["title"] as? String
        cell.detailTextLabel?.text = product["price"] as? String
                
        if let imageUrlString = product["image"] as? String, let imageUrl = URL(string: imageUrlString) {
            loadImage(url: imageUrl) { image in
                DispatchQueue.main.async {
                    cell.imageView?.image = image
                    cell.setNeedsLayout()
                }
            }
        }

        return cell
    }
            
    func loadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                completion(UIImage(data: data))
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
