//
//  SearchViewController.swift
//  EleganceHub
//
//  Created by Shimaa on 01/06/2024.
//

import UIKit
import RxSwift
import RxCocoa


class SearchViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var txtSearchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    var disposeBag = DisposeBag()
    var searchViewModel: SearchViewModel!
    var products: [ProductModel] = []
    var productList: [ProductModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        self.searchTableView.register(UINib(nibName: "SearchProductCell", bundle: nil), forCellReuseIdentifier: "searchCell")
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.txtSearchBar.delegate = self
        self.searchTableView.rowHeight = 100
       
        
        self.searchTableView.separatorStyle = .singleLine
        
//        self.searchTableView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -10)
        NSLayoutConstraint.activate([
                    self.searchTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
                    self.searchTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
                    self.searchTableView.topAnchor.constraint(equalTo: self.txtSearchBar.bottomAnchor, constant: 8),
                    self.searchTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16)
                ])
                
        searchViewModel = SearchViewModel(networkManager: Network())
        searchViewModel.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.products = self?.searchViewModel.result ?? []
                self?.searchTableView.reloadData()
            }
        }
        searchViewModel.getItems()
        setupSearchBar()
    }
    
    func setupSearchBar() {
        txtSearchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.filterProducts(with: query)
            })
            .disposed(by: disposeBag)
    }
    
    func filterProducts(with query: String) {
        if query.isEmpty {
            products = productList
        } else {
            products = productList.filter { product in
                if let title = product.title {
                    return title.lowercased().contains(query.lowercased())
                }
                return false
            }
        }
        searchTableView.reloadData()
    }




    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return products.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchProductCell
            cell.setProductToTableCell(product: products[indexPath.row])
            
            
            
            cell.layer.masksToBounds = false
                    cell.layer.shadowColor = UIColor.black.cgColor
                    cell.layer.shadowOffset = CGSize(width: 0, height: 2)
                    cell.layer.shadowOpacity = 0.2
                    cell.layer.shadowRadius = 2
            return cell
        }
        
    @IBAction func navigateBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func filterByPrice(_ sender: Any) {
        products = products.sorted(by:  {Float($0.variants?[0].price ?? "") ?? 0 < Float($1.variants?[0].price ?? "") ?? 0})
        searchTableView.reloadData()
    }
    
    
    @IBAction func filterByRate(_ sender: Any) {
        products = products.sorted(by:  {Float($0.templateSuffix ?? "") ?? 0 > Float($1.templateSuffix ?? "") ?? 0})
        searchTableView.reloadData()
    }
    
    
    @IBAction func filterByLetters(_ sender: Any) {
        products = products.sorted { Utilities.splitName(text: $0.title ?? "", delimiter: " | ") < Utilities.splitName(text: $1.title ?? "", delimiter: " | ") }
                searchTableView.reloadData()
    }
    
    
    
    
}
