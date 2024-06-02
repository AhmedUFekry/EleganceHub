//
//  ShippingAddressViewController.swift
//  EleganceHub
//
//  Created by AYA on 02/06/2024.
//

import UIKit

class ShippingAddressViewController: UIViewController {
    
    @IBOutlet weak var appBar:CustomAppBarUIView!
    @IBOutlet weak var tableView:UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
      //  tableView.dataSource = self
        tableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        commenInit()
    }
    private func commenInit(){
        appBar.secoundTrailingIcon.isHidden = true
        appBar.lableTitle.text = "Shipping Address"
        appBar.trailingIcon.setImage(UIImage(named: "add"), for: .normal)
        appBar.backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        appBar.trailingIcon.addTarget(self, action: #selector(addNewLocation), for: .touchUpInside)
        
    }
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func addNewLocation(){
        self.navigationController?.present(LocationViewController(), animated: true)
                
    }

}

//extension ShippingAddressViewController:UITableViewDataSource{
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//}

extension ShippingAddressViewController:UITableViewDelegate{
    
}
