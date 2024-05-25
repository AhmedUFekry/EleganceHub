//
//  PaymentViewController.swift
//  EleganceHub
//
//  Created by AYA on 25/05/2024.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let paymentList:[PaymentMethodModel] = [PaymentMethodModel(paymentMethod: "Credit Card", imageName: "CreditCard"),PaymentMethodModel(paymentMethod: "Apple Pay", imageName: "applePayDark"),PaymentMethodModel(paymentMethod: "Paypal", imageName: "Paypal"),PaymentMethodModel(paymentMethod: "Cash on delivery", imageName: "cashOnDelivery")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

       let paymentNibCell = UINib(nibName: "PaymentMethodTableViewCell", bundle: nil)
        tableView.register(paymentNibCell, forCellReuseIdentifier: "PaymentMethodTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension PaymentViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTableViewCell", for: indexPath) as! PaymentMethodTableViewCell
        let payment = paymentList[indexPath.row]
        cell.paymentMethodImage.image = UIImage(named: payment.imageName)
        cell.paymentMethodLabel.text = payment.paymentMethod
        return cell
    }
    
    
}

extension PaymentViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? PaymentMethodTableViewCell{
                cell.contentView.backgroundColor = UIColor.black
                if(indexPath.row == 1){
                   
                    cell.paymentMethodImage.image = UIImage(named: "applePayLight")
                }
            cell.paymentMethodLabel.textColor = UIColor.white
            }
        }

        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            if let cell = tableView.cellForRow(at: indexPath) as? PaymentMethodTableViewCell{
                cell.contentView.backgroundColor = UIColor.white
                cell.paymentMethodLabel.textColor = UIColor.black
                if(indexPath.row == 1){
                   
                    cell.paymentMethodImage.image = UIImage(named: "applePayDark")
                }

            }
        }
}
