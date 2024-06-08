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
    
    @IBOutlet weak var filterByPriceButton: UIButton!
    @IBOutlet weak var filterByLettersButton: UIButton!
    @IBOutlet weak var removeFiltersButton: UIButton!
    
    var disposeBag = DisposeBag()
    var searchViewModel: SearchViewModel!
    var products: [ProductModel] = []
    var productList: [ProductModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.reloadData()
        configureRoundedButtons()
        setupButtons()
        self.searchTableView.register(UINib(nibName: "SearchProductCell", bundle: nil), forCellReuseIdentifier: "searchCell")
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.txtSearchBar.delegate = self
        self.searchTableView.rowHeight = 100
       
        searchViewModel = SearchViewModel(networkManager: NetworkService())
        searchViewModel.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.products = self?.searchViewModel.result ?? []
                self?.productList = self?.products ?? []
                self?.searchTableView.reloadData()
            }
        }
        searchViewModel.getItems()
        setupSearchBar()
    }
    
    func configureRoundedButtons() {
        let buttons: [UIButton] = [filterByPriceButton, filterByLettersButton, removeFiltersButton]
        buttons.forEach { button in
            button.layoutIfNeeded()
            button.layer.cornerRadius = button.bounds.height / 2
            button.clipsToBounds = true
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.black.cgColor
        }
    }

    
    func setupButtons() {
        let buttons: [UIButton] = [filterByPriceButton, filterByLettersButton,removeFiltersButton]
        buttons.forEach { button in
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
            button.tintColor = .black
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        }
    }
        
    @objc func buttonPressed(_ sender: UIButton) {
        let buttons: [UIButton] = [ filterByPriceButton,  filterByLettersButton]
        buttons.forEach { button in
            if button == sender {
                button.backgroundColor = .black
                button.setTitleColor(.white, for: .normal)
                button.tintColor = .white
                button.layer.borderColor = UIColor.black.cgColor
            } else {
                button.backgroundColor = .white
                button.setTitleColor(.black, for: .normal)
                button.tintColor = .black
                button.layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    
    func setupSearchBar() {
        txtSearchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.filterProducts(searchText: query)
            })
            .disposed(by: disposeBag)
    }
    
    func filterProducts(searchText: String) {
        let lowercaseSearchText = searchText.lowercased()
        
        if searchText.isEmpty {
            products = productList
        } else {
            products = productList.filter { product in
                guard let title = product.title else { return false }
                let parts = title.components(separatedBy: " | ")
                
                if let lastPart = parts.last {
                    return lastPart.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().contains(lowercaseSearchText)
                } else {
                    return false
                }
            }
        }
        searchTableView.reloadData()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchProductCell
                cell.setProductToTableCell(product: products[indexPath.section])
                
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
    
    
    @IBAction func filterByLetters(_ sender: Any) {
        products = products.sorted { Utilities.splitName(text: $0.title ?? "", delimiter: " | ") < Utilities.splitName(text: $1.title ?? "", delimiter: " | ") }
                searchTableView.reloadData()
    }
    
    @IBAction func removeAllFilters(_ sender: Any) {
        products = productList
        searchTableView.reloadData()
    }
    
    
}
