//
//  CartViewController.swift
//  EleganceHub
//
//  Created by AYA on 25/05/2024.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var countOfItemInCart: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cartNibCell = UINib(nibName: "CartTableViewCell", bundle: nil)
        cartTableView.register(cartNibCell, forCellReuseIdentifier: "CartTableViewCell")
            
        countOfItemInCart.backgroundColor  = UIColor.red
        countOfItemInCart.layer.cornerRadius = 8
        countOfItemInCart.layer.masksToBounds = true
        
        cartTableView.dataSource = self
        cartTableView.delegate = self
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkoutBtn(_ sender: UIButton) {
        let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    
}

extension CartViewController: UITableViewDelegate{
    
}

extension CartViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        return cell
    }
    
    
}
